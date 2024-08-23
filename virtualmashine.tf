resource "azurerm_resource_group" "applicationgroup" {
  name     = "applicationgroup"
  location = "West Europe"
}

moved {
  from = azurerm_public_ip.t-publicip
  to   = module.vm["vm1"].azurerm_public_ip.t-publicip.0
}

locals {
  vms = {
    vm1 = {
      name               = "vm1"
      backup_policy_name = "vm_weekly_1h"
      admin_username     = "chi.nguyen"
      admin_password     = module.keyvault.vm_password_secret
      nic = {
        name = "vm1nic"
        ip_config = {
          name       = "internal"
          subnet_key = "app-subnet"
          public_ip = {
            name              = "vm1publicip"
            allocation_method = "Static"
          }
        }
      }
    }
    vm2 = {
      name               = "vm2"
      backup_policy_name = "vm_weekly_1h"
      admin_username     = "chi.nguyen"
      admin_password     = module.keyvault.vm_password_secret
      nic = {
        name = "vm2nic"
        ip_config = {
          name       = "internal"
          subnet_key = "app-subnet"
          public_ip = {
            name              = "vm2publicip"
            allocation_method = "Static"
          }
        }
      }
    }
  }
}

moved {
  from = module.vm
  to   = module.vm["vm1"]
}

module "vm" {
  source   = "./modules/vm/"
  // iterates over local and creates an instance
  for_each = local.vms

  resource_group   = azurerm_resource_group.applicationgroup.name
  location         = azurerm_resource_group.applicationgroup.location
  configuration    = each.value
  subnet_reference = module.network.subnet_reference
}

moved {
  from = azurerm_windows_virtual_machine.t-vm
  to   = module.vm.azurerm_windows_virtual_machine.t-vm
}

moved {
  from = azurerm_network_interface.t-interface
  to   = module.vm.azurerm_network_interface.t-interface
}

