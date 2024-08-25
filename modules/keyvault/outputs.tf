
output "vm1_password_secret" {
  value = data.azurerm_key_vault_secret.vm1password.value
  sensitive = true
}

output "vm2_password_secret" {
  value = data.azurerm_key_vault_secret.vm2password.value
  sensitive = true
}


output "db_password_secret" {
  value = data.azurerm_key_vault_secret.dbpassword.value
}

variable "naming" {
  description = "Naming module object"
}