resource "azurerm_resource_group" "webgroup" {
  name     = "web-${module.naming.resource_group.name}"
  location = "West Europe"
  tags = local.common_tags
}


//Beim Umzug zu Modulen:
moved {
  from = azurerm_virtual_network.vnet
  to = module.network.azurerm_virtual_network.vnet
}

moved {
  from = azurerm_subnet.subnetA
  to = module.network.azurerm_subnet.subnetA["web"]
}


removed {
  from = azurerm_network_security_group.nsg
  lifecycle {
    destroy = false
  }
}

module "network" {
  source         = "./modules/network/"
  resource_group = azurerm_resource_group.webgroup.name
  location       = azurerm_resource_group.webgroup.location
  configuration = var.network_configuration
  naming = module.naming
  tags = local.common_tags
}
