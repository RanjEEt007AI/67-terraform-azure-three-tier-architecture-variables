# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "${local.name_prefix}-vnet"
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = local.common_tags
}

# Subnets
resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.address_prefixes
}

# Network Security Groups
resource "azurerm_network_security_group" "nsg" {
  for_each = local.tiers

  name                = "${local.name_prefix}-${each.value.nsg_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = local.common_tags
}

# Web NSG - Allow HTTP and HTTPS

resource "azurerm_network_security_rule" "web_rules" {
  for_each = {
    http = {
      priority = 100
      port     = "80"
    }
    https = {
      priority = 110
      port     = "443"
    }
  }

  name                        = "allow-${each.key}"
  priority                    = each.value.priority
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value.port
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg["web"].name
}

# SSH access only from admin IP
resource "azurerm_network_security_rule" "ssh" {
  for_each = local.tiers

  name                        = "allow-ssh"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.admin_source_cidr
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg[each.key].name
}

# App tier - only Web subnet can access port 8080
resource "azurerm_network_security_rule" "app_rule" {
  name                        = "allow-web-to-app"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = var.subnets["web"].address_prefixes[0]
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg["app"].name
}

# DB tier - only App subnet can access PostgreSQL
resource "azurerm_network_security_rule" "db_rule" {
  name                        = "allow-app-to-db"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5432"
  source_address_prefix       = var.subnets["app"].address_prefixes[0]
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg["db"].name
}

# NSG - Subnet association
resource "azurerm_subnet_network_security_group_association" "association" {
  for_each = local.tiers

  subnet_id = azurerm_subnet.subnets[each.value.subnet_key].id

  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}

# Public IP for Web VM only
resource "azurerm_public_ip" "web" {
  name                = "${local.name_prefix}-web-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = local.common_tags
}

# Network Interfaces
resource "azurerm_network_interface" "nic" {
  for_each = local.tiers

  name                = "${local.name_prefix}-${each.key}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnets[each.value.subnet_key].id
    private_ip_address_allocation = "Dynamic"

    public_ip_address_id = each.value.public_ip ? azurerm_public_ip.web.id : null
  }

  tags = local.common_tags
}

# Linux Virtual Machines
resource "azurerm_linux_virtual_machine" "vm" {
  for_each = local.tiers

  name                = "${local.name_prefix}-${each.value.vm_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = var.vm_size

  admin_username                  = var.admin_username
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(file(each.value.custom_script))

  boot_diagnostics {}

  tags = merge(local.common_tags, {
    tier = each.key
  })

  depends_on = [
    azurerm_subnet_network_security_group_association.association
  ]
}


