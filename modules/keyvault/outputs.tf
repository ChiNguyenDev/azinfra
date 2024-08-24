
output "vm_password_secret" {
  value = data.azurerm_key_vault_secret.vmpassword.value
  sensitive = true
}

variable "naming" {
  description = "Naming module object"
}