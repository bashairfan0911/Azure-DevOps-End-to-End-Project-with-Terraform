terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstagebackend2024piyush"  # TODO: Change storage account name (must match scripts/dev.sh)
    container_name      = "tfstate"
    key                 = "stage.tfstate"
  }
}

provider "azurerm" {
  features {}
}