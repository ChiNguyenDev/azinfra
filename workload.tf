resource "azurerm_resource_group" "applicationgroup" {
  name     = "app-${module.naming.resource_group.name}"
  location = "West Europe"
}

locals {
  vms = {
    vm1 = {
      backup_policy_name = "vm_weekly_1h"
      admin_username     = "chi.nguyen"
      admin_password     = module.keyvault.vm_password_secret
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
    vm2 = {
      backup_policy_name = "vm_weekly_1h"
      admin_username     = "chi.nguyen"
      admin_password     = module.keyvault.vm_password_secret
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


module "vm" {
  source   = "./modules/vm/"
  // iterates over local and creates an instance
  for_each = local.vms

  resource_group   = azurerm_resource_group.applicationgroup.name
  location         = azurerm_resource_group.applicationgroup.location
  configuration    = each.value
  subnet_reference = module.network.subnet_reference
  naming = module.naming
  vm_name = each.key
  environment_decleration = var.environment_decleration
}

module "naming" {
  source  = "Azure/naming/azurerm"
  suffix = [ var.environment_decleration ]
  prefix = [ "azrinfra" ]
}
