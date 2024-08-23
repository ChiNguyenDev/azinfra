variable "tags" {
  nullable    = false
  description = "(optional) tags for the Azure resources"
  type        = map(string)
  default = {
  }
}

variable "location" {
  nullable    = false
  description = "(required) location for Azure resources"
  type        = string
  default     = "West Europe"
}

variable "resource_group" {
  nullable    = false
  description = "(required) resource group for Azure resources"
  type        = string
}

variable "configuration" {
  nullable    = false
  description = "(required) configuration for the VNet"
  type = object({
    name               = string
    backup_policy_name = optional(string)
    size               = optional(string, "Standard_F2")
    admin_username     = string
    admin_password     = string

    os_disk = optional(object({
      caching              = optional(string, "ReadWrite")
      storage_account_type = optional(string, "Standard_LRS")
      }), {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
      }
    )

    source_image_reference = optional(object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
      }),
      {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2016-Datacenter"
        version   = "latest"
      }
    )

    nic = object({
      name = string
      ip_config = object({
        name                          = string
        subnet_key                    = string
        private_ip_address_allocation = optional(string, "Dynamic")
        public_ip = optional(object({
          name = string
          allocation_method = optional(string, "Dynamic")
          sku = optional(string, "Standard")
        }))
      })
    })
  })
}

variable "subnet_reference" {
  description = "(required) this is the subnet reference"
  type = map(object({
    id = string
  }))
}
