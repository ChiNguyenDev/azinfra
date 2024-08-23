resource "azurerm_resource_group" "webgroup" {
  name     = "webgroup"
  location = "West Europe"
}


//Beim Umzug zu Modulen:
moved {
  from = azurerm_virtual_network.t-vnet
  to = module.network.azurerm_virtual_network.t-vnet
}

moved {
  from = azurerm_subnet.t-subnetA
  to = module.network.azurerm_subnet.t-subnetA["web"]
}


removed {
  from = azurerm_network_security_group.t-nsg
  lifecycle {
    destroy = false
  }
}

module "network" {
  source         = "./modules/vnet/"
  resource_group = azurerm_resource_group.webgroup.name
  location       = azurerm_resource_group.webgroup.location
  configuration = var.network_configuration
}
