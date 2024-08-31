resource "azurerm_mssql_server" "dbserver" {
  name                         = var.naming.mssql_server.name
  resource_group_name          = var.resource_group
  location                     = var.location
  version                      = var.configuration.server.version
  administrator_login          = var.configuration.server.administrator_login
  administrator_login_password = var.db_password_secret
  minimum_tls_version          = var.configuration.server.minimum_tls_version

  azuread_administrator {
    login_username = var.configuration.server.azuread_administrator.login_username
    object_id      = var.configuration.server.azuread_administrator.object_id
  }
}


resource "azurerm_mssql_database" "example" {
  name           = var.naming.mssql_database.name
  server_id      = azurerm_mssql_server.dbserver.id
  collation      = var.configuration.db.collation
  license_type   = var.configuration.db.license_type
  max_size_gb    = var.configuration.db.max_size_gb
  read_scale     = var.configuration.db.read_scale
  sku_name       = var.configuration.db.sku_name
  zone_redundant = var.configuration.db.zone_redundant
  enclave_type   = var.configuration.db.enclave_type

  tags = var.tags

  /*
  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
  */
}