variable "tags" {
  nullable = false
  description = "(optional) tags for the Azure resources"
  type = map(string)
  default = {
  }
}

variable "location" {
    nullable = false
    description = "(required) location for Azure resources"
    type = string
    default = "West Europe"
}

variable "resource_group" {
    nullable = false
    description = "(required) resource group for Azure resources"
    type = string
}

variable "configuration" {
  nullable = false
  description = "(required) configuration for the VNet"
  type = object({
    vnet = object({
      name = string
      address_space = list(string)
    })
    subnet = map(object({
        name = string
        address_prefix = string
        nsg_association = optional(string, null) //wird als null gesetzt
    })) 
    //Option mehrere NSG
    nsg = map(object({
      name = string
      rule = map(object({
        name = string
        priority = number
        direction = string
        access = string
        protocol = optional(string, "Tcp")
        source_port_range = optional(string, "*") //Kann man beim Aufruf weglassen
        destination_port_range = string
        source_address_prefix      = optional(string, "*")
        destination_address_prefix = optional(string, "*")
      }))
    }))
  })
}
