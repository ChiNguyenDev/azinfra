variable "tags" {
  nullable    = false
  description = "(optional) tags for the Azure resources"
  type        = map(string)
  default = {
  }
}

variable "location" {
  nullable    = false
  description = "(optional) location for Azure resources"
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
  description = "(required) configuration for the backup"
  type = object({
    recovery_vault = object({
      name                = string
      sku                 = optional(string, "Standard")
      soft_delete_enabled = optional(bool, false)
    })
  })
}

variable "backup_policy" {
  type = map(object({
    timezone = string
    backup = object({
      frequency = string
      time      = string
      weekdays  = optional(list(string))
    })
    retention_daily = optional(object({
      count = number
    }))
    retention_weekly = optional(object({
      count    = number
      weekdays = list(string)
    }))
    retention_monthly = optional(object({
      count    = number
      weekdays = list(string)
      weeks    = list(string)
    }))
    retention_yearly = optional(object({
      count    = number
      weekdays = list(string)
      weeks    = list(string)
      months   = list(string)
    }))
  }))
}

variable "vm_reference" {
  description = "(required) this is the reference for the vm"
  type = map(object({
    id = string
    backup_policy_name = optional(string)
  }))
}
