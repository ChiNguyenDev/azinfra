module "loadbalancer" {
  source = "./modules/loadbalancer"
  resource_group = azurerm_resource_group.webgroup.name
  configuration = var.loadbalancer_configuration
  naming = module.naming
  tags = local.common_tags
  nic_reference = {
    // iterates over all vm's and creates a new key/value map that fits nic_reference
    // module.vm is a map of instances
    for vm_key, vm_value in module.vm : vm_key => {
      id = vm_value.network_interface.id  
      ip_config_name = vm_value.network_interface.ip_config_name
    }
  }
}
