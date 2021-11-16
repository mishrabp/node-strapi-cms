# We strongly recommend using the required_providers block to "the
# Azure Provider source and version being used

terraform {
  backend "azurerm" {
    resource_group_name   = "terraformstoragergp"
    storage_account_name  = "terraformsabibhu2021"
    container_name        = "node-strapi-cms-terraform"
    key                   = "terraform.tfstate"
  }
}

resource "random_pet" "prefix" {}

provider "azurerm" {
  features {}
}

#Defining Variables
#Define variables
variable "resource_group_name" {
    default = "#{resourceGroup}#"
    description = "the name of the resource group"
}

variable "resource_group_location" {
    default = "#{resourceLocation}#"
    description = "the location of the resource group"
}

variable "app_service_plan_name" {
    default = "#{appServicePlan}#"
    description = "the name of the app service plan"
}

variable "app_service_name_prefix" {
    default = "#{appServicePrefix}#"
    description = "begining part of the app service name"
}

#Creating a resource group
resource "azurerm_resource_group" "my" {
    name = var.resource_group_name
    location = var.resource_group_location
}

#Creating an App Service plan
resource "azurerm_app_service_plan" "my" {
    name = var.app_service_plan_name
    location = azurerm_resource_group.my.location
    resource_group_name = azurerm_resource_group.my.name

    kind = "Linux"
    reserved = true

    sku {
        tier = "Basic"
        size = "B1"
    }

}

#Creating an App Service for Development
resource "azurerm_app_service" "dev" {
    name = "${var.app_service_name_prefix}-dev"
    location = azurerm_resource_group.my.location
    resource_group_name = azurerm_resource_group.my.name
    app_service_plan_id = azurerm_app_service_plan.my.id 

    site_config {
        dotnet_framework_version = "v4.0"
        scm_type                 = "LocalGit"
    }
    
    app_settings = {
        "DATABASE_HOST" = "devopsmasterlinuxvm.centralus.cloudapp.azure.com"
        "DATABASE_SRV" = "false"
        "DATABASE_PORT" = "9003"
        "DATABASE_NAME" = "strapicms"
        "DATABASE_USERNAME" = "mongoadmin"
        "DATABASE_PASSWORD" = "passw0rd!"
        "AUTHENTICATION_DATABASE" = ""
        "DATABASE_SSL" ="false"
    }

    connection_string {
        name  = "Database"
        type  = "SQLServer"
        value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
    }
}