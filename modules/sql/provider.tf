terraform {
required_version = ">=1.9.0" //Mindestversion angeben
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">=3.113.0"
    }
  }
}

