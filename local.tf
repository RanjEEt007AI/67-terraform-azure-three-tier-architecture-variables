locals {
  name_prefix = "${var.project_name}-${var.environment}"

  tiers = {
    web = {
      vm_name       = "vm-web"
      nsg_name      = "nsg-web"
      subnet_key    = "web"
      public_ip     = true
      custom_script = "${path.module}/cloud-init/web.sh"
    }

    app = {
      vm_name       = "vm-app"
      nsg_name      = "nsg-app"
      subnet_key    = "app"
      public_ip     = false
      custom_script = "${path.module}/cloud-init/app.sh"
    }

    db = {
      vm_name       = "vm-db"
      nsg_name      = "nsg-db"
      subnet_key    = "db"
      public_ip     = false
      custom_script = "${path.module}/cloud-init/db.sh"
    }
  }

  common_tags = merge(var.tags, {
    environment = var.environment
  })
}