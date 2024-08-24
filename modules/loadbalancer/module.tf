resource "azurerm_lb" "loadbalancer" {
  name                = var.naming.lb.name
  location            = var.location
  resource_group_name = var.resource_group
  sku = var.configuration.sku
  frontend_ip_configuration {
    name                 = var.configuration.frontend_ip_configuration.name
    public_ip_address_id = azurerm_public_ip.lb_ip.id
  }
  tags = var.tags
}

resource "azurerm_public_ip" "lb_ip" {
  name                = "lb-${var.naming.public_ip.name}"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = var.configuration.public_ip.allocation_method
  sku = var.configuration.public_ip.sku
  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "lb_backendpool" {
  loadbalancer_id = azurerm_lb.loadbalancer.id  
  name            = var.configuration.backendpool.name
}

resource "azurerm_network_interface_backend_address_pool_association" "lb_backendassociation" {
  for_each = var.nic_reference
  network_interface_id    = each.value.id 
  ip_configuration_name   = each.value.ip_config_name
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_backendpool.id  
}


resource "azurerm_lb_probe" "lb_probe" {
  loadbalancer_id     = azurerm_lb.loadbalancer.id
  name                = var.configuration.probe.name
  port                = var.configuration.probe.port
}

resource "azurerm_lb_rule" "lb_rule" {
  for_each = var.configuration.lb_rule
  loadbalancer_id                = azurerm_lb.loadbalancer.id
  name                           = each.value.name
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = azurerm_lb.loadbalancer.frontend_ip_configuration[0].name
  probe_id = azurerm_lb_probe.lb_probe.id
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb_backendpool.id]
}