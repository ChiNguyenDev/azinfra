terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.113.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "stategroup"  
    storage_account_name = "stateacc1999"                      
    container_name       = "state"      
    key                  = "prod.terraform.tfstate" //Datei, die erstellt wird
  }
}

provider "random" {
  # Configuration options
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features        {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}