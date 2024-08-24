variable "location" {
  nullable    = false
  description = "(required) location for Azure resources"
  type        = string
  default     = "West Europe"
}

variable "configuration" {
    nullable = false
    description = "(required) key vault for the vm password"
    type = object({
      name = string 
      resource_group_name = string
      secrets = object({
        vm_secret_name = string
        db_secret_name = string
      })
    })
}
