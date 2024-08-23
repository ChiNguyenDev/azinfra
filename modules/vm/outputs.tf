output "id" {
  value = azurerm_windows_virtual_machine.t-vm.id
}

output "name" {
    value = azurerm_windows_virtual_machine.t-vm.name
}

output "backup_policy_name" {
    value = var.configuration.backup_policy_name
}

// [0] because we only have one ip config
output "network_interface" {
  value = {
    id = azurerm_network_interface.t-interface.id
    ip_config_name = azurerm_network_interface.t-interface.ip_configuration[0].name  
  }
}


