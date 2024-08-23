
output "vm_password_secret" {
  value = data.azurerm_key_vault_secret.vmpassword.value
  sensitive = true
}