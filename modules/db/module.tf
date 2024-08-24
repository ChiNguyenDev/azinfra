resource "azurerm_mssql_server" "dbserver" {
  name                         = var.naming.mssql_database.name
  resource_group_name          = var.resource_group
  location                     = var.location
  version                      = var.configuration.db.version
  administrator_login          = var.configuration.db.administrator_login
  administrator_login_password = var.db_password_secret
  minimum_tls_version          = var.configuration.db.minimum_tls_version

  azuread_administrator {
    login_username = var.configuration.db.azuread_administrator.login_username
    object_id      = var.configuration.db.azuread_administrator.object_id
  }
}