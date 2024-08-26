
output "vm_password_secret" {
  value = data.azurerm_key_vault_secret.vmpassword.value
  sensitive = true
}

output "db_password_secret" {
  value = data.azurerm_key_vault_secret.dbpassword.value
}

variable "naming" {
  description = "Naming module object"
}