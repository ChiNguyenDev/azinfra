variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID"
}

variable "network_configuration" {
  description = "(required) this is the configuration for the network"
  type        = any
}

variable "keyvault_configuration" {
  description = "(required) this is the configuration for the keyvault & vm password"
  type        = any
}

variable "backup_configuration" {
  description = "(required) this is the configuration for the backup"
  type        = any
}

variable "loadbalancer_configuration" {
  description = "(required) this is the configuration for the loadbalancer"
  type        = any
}
