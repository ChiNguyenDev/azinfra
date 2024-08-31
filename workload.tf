resource "azurerm_resource_group" "applicationgroup" {
  name     = "app-${module.naming.resource_group.name}"
  location = "West Europe"
  tags = local.common_tags
}

locals {
  common_tags = {
    project = "azrinfra"
    environment = var.environment_decleration
  }
}

// definition of all the vm's
locals {
  vms = {
    vm-git-cicd = {
      backup_policy_name = "vm_weekly_1h"
      admin_username     = "chi.nguyen"
      admin_password     = module.keyvault.vm1_password_secret
      nic = {
        ip_config = {
          name       = "internal"
          subnet_key = "app"
          public_ip = {
            allocation_method = "Static"
          }
        }
      }
    }
    vm-smtp = {
      backup_policy_name = "vm_weekly_1h"
      admin_username     = "chi.nguyen"
      admin_password     = module.keyvault.vm2_password_secret
      nic = {
        ip_config = {
          subnet_key = "app"
          public_ip = {
            allocation_method = "Static"
          }
        }
      }
    }
  }
}

resource "azurerm_dns_zone" "dns_zone" {
  name                = "${module.naming.dns_zone.name}.com"
  resource_group_name = azurerm_resource_group.webgroup.name
}

module "vm" {
  source   = "./modules/vm/"
  // iterates over vm's defined as locals and creates instances
  for_each = local.vms
  resource_group   = azurerm_resource_group.applicationgroup.name
  location         = azurerm_resource_group.applicationgroup.location
  configuration    = each.value
  subnet_reference = module.network.subnet_reference
  dns_zone_name = azurerm_dns_zone.dns_zone.name
  web_resource_group = azurerm_resource_group.webgroup.name
  naming = module.naming
  tags = local.common_tags
  vm_name = each.key
  environment_decleration = var.environment_decleration
}

module "naming" {
  source  = "Azure/naming/azurerm"
  suffix = [ var.environment_decleration ]
  prefix = [ "cl-ops" ]
}

// storage for logs, builds
resource "azurerm_storage_account" "allpurposestorage" {
  name                     = "allpurposestorage2210"
  resource_group_name      = azurerm_resource_group.applicationgroup.name
  location                 = azurerm_resource_group.applicationgroup.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = local.common_tags
}