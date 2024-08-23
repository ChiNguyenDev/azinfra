module "keyvault" {
  source = "./modules/keyvault"
  configuration = var.keyvault_configuration
}
