locals {
  vm1_password = "vm1password"
  vm2_password = "vm2password"
}

data "azurerm_key_vault" "keyvault" {
  name                = var.configuration.name
  resource_group_name = var.configuration.resource_group_name
}

// fetch the values of existing key vault
data "azurerm_key_vault_secret" "vm1password" {
  name         = local.vm1_password
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

data "azurerm_key_vault_secret" "vm2password" {
  name         = local.vm2_password
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

data "azurerm_key_vault_secret" "dbpassword" {
  name         = var.configuration.secrets.db_secret_name
  key_vault_id = data.azurerm_key_vault.keyvault.id
}
