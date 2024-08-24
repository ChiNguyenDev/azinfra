locals {
  //fileset: reads all the files, that follow a certain pattern
  //file: reads all files at a certain path
  //ymldecode: translates yml string into a terraform object
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
  vm_reference = module.vm // map of vm instances defined as locals
  naming = module.naming
  tags = local.common_tags
}
