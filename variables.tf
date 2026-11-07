variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "three-tier"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "Central India"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "rg-three-tier-dev"
}

variable "vnet_address_space" {
  description = "VNet address space"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnets" {
  description = "Three tier subnet configuration"

  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))

  default = {
    web = {
      name             = "snet-web"
      address_prefixes = ["10.0.1.0/24"]
    }

    app = {
      name             = "snet-app"
      address_prefixes = ["10.0.2.0/24"]
    }

    db = {
      name             = "snet-db"
      address_prefixes = ["10.0.3.0/24"]
    }
  }
}

variable "vm_size" {
  description = "Azure VM size"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Linux VM admin username"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
}

variable "admin_source_cidr" {
  description = "Your public IP CIDR for SSH access"
  type        = string
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)

  default = {
    project     = "three-tier-architecture"
    environment = "dev"
    managed_by  = "terraform"
  }
}