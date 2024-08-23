resource "azurerm_virtual_network" "t-vnet" {
  name                = var.configuration.vnet.name
  location            = var.location
  resource_group_name = var.resource_group
  address_space       = var.configuration.vnet.address_space
}

resource "azurerm_subnet" "t-subnetA" {
  for_each = var.configuration.subnet
  name                 = each.value.name
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.t-vnet.name
  address_prefixes     = [each.value.address_prefix]
}

resource "azurerm_network_security_group" "t-nsg" {
  for_each = var.configuration.nsg
  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group

  //dynamic für eine Gruppe untergeordneter Einheiten einer Ressource
  dynamic "security_rule" {
    for_each = each.value.rule
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "t_association" {
  for_each = {
    for subnet_key, subnet_value in var.configuration.subnet:
    subnet_key => subnet_value
    //filtert alle nulls raus
    if subnet_value.nsg_association != null 
  }
  subnet_id                 = azurerm_subnet.t-subnetA[each.key].id
  network_security_group_id = azurerm_network_security_group.t-nsg[each.value.nsg_association].id
}