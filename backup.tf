locals {
  //fileset liest alle Dateien aus, die einem Muster folgen
  //file: list Datei aus an einem bestimmten Pfad
  //ymldecode: übersetzt yml string in ein terraform objekt
  backup_policy_files = {for file in fileset(var.backup_configuration.recovery_vault.backup_policies_path, "*.yml"):
    replace(file, ".yml", "") => yamldecode(file("${var.backup_configuration.recovery_vault.backup_policies_path}/${file}"))
    if !strcontains(file, "example.yml")
  }
}

module "backup" {
  source         = "./modules/backup"
  resource_group = azurerm_resource_group.applicationgroup.name
  location       = azurerm_resource_group.applicationgroup.location  
  configuration  = var.backup_configuration
  backup_policy  = local.backup_policy_files
  vm_reference = module.vm // map of vm instances
  naming = module.naming
}
