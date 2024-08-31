resource "azurerm_public_ip" "azrinfra_publicip" {
  count = var.configuration.nic.ip_config.public_ip != null ? 1 : 0
  name                = "${var.vm_name}-${var.naming.public_ip.name}"
  resource_group_name = var.resource_group
  location            = var.location
  allocation_method   = var.configuration.nic.ip_config.public_ip.allocation_method
  sku = var.configuration.nic.ip_config.public_ip.sku
  depends_on = [ var.resource_group ]
  tags = var.tags
}

resource "azurerm_network_interface" "azrinfra_interface" {
  name                = "${var.vm_name}-${var.naming.network_security_group.name}"
  location            = var.location
  resource_group_name = var.resource_group
  ip_configuration {
    name                          = var.configuration.nic.ip_config.name
    subnet_id                     = var.subnet_reference[var.configuration.nic.ip_config.subnet_key].id
    private_ip_address_allocation = var.configuration.nic.ip_config.private_ip_address_allocation
    /*
    first possibility:
    public_ip_address_id          = length(azurerm_public_ip.azrinfra_publicip) > 0 ? azurerm_public_ip.azrinfra_publicip.0.id : null
    */
    public_ip_address_id = one(azurerm_public_ip.azrinfra_publicip.*.id)
  }
  tags = var.tags
}


resource "azurerm_linux_virtual_machine" "azrinfra_vm" {
  name                = "${var.vm_name}-${var.environment_decleration}"
  resource_group_name = var.resource_group
  location            = var.location
  size                = var.configuration.size
  admin_username      = var.configuration.admin_username
  admin_password      = var.configuration.admin_password
  network_interface_ids = [
    azurerm_network_interface.azrinfra_interface.id,
  ]

  disable_password_authentication = var.configuration.disable_password_authentication


  os_disk {
    caching              = var.configuration.os_disk.caching
    storage_account_type = var.configuration.os_disk.storage_account_type
  }

  source_image_reference {
    publisher = var.configuration.source_image_reference.publisher
    offer     = var.configuration.source_image_reference.offer
    sku       = var.configuration.source_image_reference.sku
    version   = var.configuration.source_image_reference.version
  }
  lifecycle {
    precondition {
        condition = strcontains(var.configuration.os_disk.storage_account_type, "LRS")
        error_message = "OS Disk should be a LRS - currently: ${var.configuration.os_disk.storage_account_type}"
    }
  }

  tags = var.tags
}

resource "azurerm_managed_disk" "source" {
  count = var.configuration.managed_disk != null? 1 : 0
  name                 = "${var.vm_name}-${var.naming.managed_disk.name}"
  location             = var.location
  resource_group_name  = var.resource_group
  storage_account_type = var.configuration.managed_disk.storage_account_type
  create_option        = var.configuration.managed_disk.create_option
  disk_size_gb         = var.configuration.managed_disk.disk_size_gb

  lifecycle {
    precondition {
        condition = strcontains(var.configuration.os_disk.storage_account_type, "LRS")
        error_message = "OS Disk should be a LRS - currently: ${var.configuration.os_disk.storage_account_type}"
    }
  }
  tags = var.tags
}



resource "azurerm_dns_a_record" "dns_a_record" {
  name                = "dns-record-${var.vm_name}"
  zone_name           = var.dns_zone_name
  resource_group_name = var.web_resource_group
  ttl                 = 300
  target_resource_id = azurerm_public_ip.azrinfra_publicip[0].id
}