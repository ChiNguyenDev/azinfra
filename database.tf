resource "azurerm_resource_group" "dbgroup" {
  name     = "db-${module.naming.resource_group.name}"
  location = "North Europe"
  tags = local.common_tags
}

module "database" {
    source = "./modules/db"
    naming = module.naming
    location = azurerm_resource_group.dbgroup.location
    resource_group = azurerm_resource_group.dbgroup.name
    configuration = var.database_configuration
    db_password_secret = module.keyvault.db_password_secret
    tags = local.common_tags
}