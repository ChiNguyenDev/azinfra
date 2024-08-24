variable "tags" {
  nullable    = false
  description = "(optional) tags for the Azure resources"
  type        = map(string)
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

variable "naming" {
  description = "Naming module object"
}

variable "db_password_secret" {
  nullable    = false
  description = "(required) this is the password for the db admin account"
  type        = string
}

variable "configuration" {
  nullable    = false
  description = "(required) this is config for the mssql database"
  type = object({
    db = object({
      version             = optional(string, "12.0")
      administrator_login = string
      minimum_tls_version = optional(string, "1.2")

      azuread_administrator = object({
        login_username = string
        object_id      = string
      })
    })
  })
}
