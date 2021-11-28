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
resource "azurerm_resource_group" "main" {
    name = var.resource_group_name
    location = var.resource_group_location
}

#Creating an App Service plan
resource "azurerm_app_service_plan" "main" {
    name = var.app_service_plan_name
    location = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name

    kind = "Linux"
    reserved = true

    sku {
        tier = "Standard"
        size = "S1"
    }

}

#Creating an App Service for Development
resource "azurerm_app_service" "main" {
    name = "${var.app_service_name_prefix}-dev"
    location = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name
    app_service_plan_id = azurerm_app_service_plan.main.id 

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
        "DATABASE_SSL" = "false"
        "NODE_ENV" = "development"
    }
}

##Creating an App Service Slot for Development
#resource "azurerm_app_service_slot" "main" {
#    name = "staging"
#    app_service_name = azurerm_app_service.main.name 
#    location = azurerm_resource_group.main.location
#    resource_group_name = azurerm_resource_group.main.name
#    app_service_plan_id = azurerm_app_service_plan.main.id 

#    site_config {
#        linux_fx_version = "NODE|12-lts"
#        app_command_line = "npm start"
#    }
    
#    app_settings = {
#        "DATABASE_HOST" = "devopsmasterlinuxvm.centralus.cloudapp.azure.com"
#        "DATABASE_SRV" = "false"
#        "DATABASE_PORT" = "9003"
#        "DATABASE_NAME" = "strapicms"
#        "DATABASE_USERNAME" = "mongoadmin"
#        "DATABASE_PASSWORD" = "passw0rd!"
#        "AUTHENTICATION_DATABASE" = ""
#        "DATABASE_SSL" ="false"
#        "NODE_ENV" = "development"
#   }
#}

#Creating an App Service for QA
resource "azurerm_app_service" "main-qa" {
    name = "${var.app_service_name_prefix}-qa"
    location = azurerm_resource_group.main-qa.location
    resource_group_name = azurerm_resource_group.main-qa.name
    app_service_plan_id = azurerm_app_service_plan.main-qa.id 

    site_config {
        linux_fx_version = "DOCKER|bpm2021acr.azurecr.io/node-strapi-cms:latest"
        always_on        = "true"
    }
    
    app_settings = {
        "DATABASE_HOST" = "devopsmasterlinuxvm.centralus.cloudapp.azure.com"
        "DATABASE_SRV" = "false"
        "DATABASE_PORT" = "9003"
        "DATABASE_NAME" = "strapicms"
        "DATABASE_USERNAME" = "mongoadmin"
        "DATABASE_PASSWORD" = "passw0rd!"
        "AUTHENTICATION_DATABASE" = ""
        "DATABASE_SSL" = "false"
        "NODE_ENV" = "development"

        WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
        # Settings for private Container Registires  
        DOCKER_REGISTRY_SERVER_URL      = "https://bpm2021acr.azurecr.io"
        DOCKER_REGISTRY_SERVER_USERNAME = "bpm2021acr"
        DOCKER_REGISTRY_SERVER_PASSWORD = "U3S=o=JCtzncrFblrLkpSVtZKW02oVfE"
    }

    identity {
        type = "SystemAssigned"
    }
}