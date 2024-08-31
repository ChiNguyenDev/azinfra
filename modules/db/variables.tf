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
    server = object({
      version             = optional(string, "12.0")
      administrator_login = string
      minimum_tls_version = optional(string, "1.2")

      azuread_administrator = object({
        login_username = string
        object_id      = string
      })
    })
    db = optional(object({
      collation      = string
      license_type   = string
      max_size_gb    = number
      read_scale     = bool
      sku_name       = string
      zone_redundant = bool
      enclave_type   = string
      }),
      {
        collation      = "SQL_Latin1_General_CP1_CI_AS"
        license_type   = "LicenseIncluded"
        max_size_gb    = 1
        read_scale     = false
        sku_name       = "S0"
        zone_redundant = false
        enclave_type   = "VBS"
      }
    )
  })
}
