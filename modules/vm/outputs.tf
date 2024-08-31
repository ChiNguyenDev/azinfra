output "id" {
  value = azurerm_linux_virtual_machine.azrinfra_vm.id
}

output "name" {
    value = azurerm_linux_virtual_machine.azrinfra_vm.name
}

output "backup_policy_name" {
    value = var.configuration.backup_policy_name
}

// [0] because we only have one ip config
output "network_interface" {
  value = {
    id = azurerm_network_interface.azrinfra_interface.id
    ip_config_name = azurerm_network_interface.azrinfra_interface.ip_configuration[0].name  
  }
}


