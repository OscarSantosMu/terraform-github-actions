terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0"
    }
  }

  # Update this block with the location of your terraform state file
  backend "azurerm" {
    resource_group_name  = "talent-tf-state-rg"
    storage_account_name = "talenttfstorageaccount"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_oidc             = true
  }
}

provider "azurerm" {
  features {}
  use_oidc = true
}

# Define any Azure resources to be created here. A simple resource group is shown here as a minimal example.
resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = local.location
}

resource "azurerm_service_plan" "linux_app_plan" {
  name                = "appserviceplan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "linux_web_app" {
  name                = "existing-app"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.linux_app_plan.location
  service_plan_id     = azurerm_service_plan.linux_app_plan.id

  site_config {}
}