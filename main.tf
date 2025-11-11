terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.app_name}-rg"
  location = var.location
}

resource "azurerm_service_plan" "asp" {
  name                = "${var.app_name}-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "backend" {
  name                = "${var.app_name}-go-backend"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    application_stack {
      go_version = "1.21"
    }
    cors {
      allowed_origins = ["*"]
    }
  }

  app_settings = {
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "true"
    "WEBSITES_PORT"                  = "8080"
  }
}

resource "azurerm_static_site" "frontend" {
  name                = "${var.app_name}-react-frontend"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku_tier            = "Free"
  sku_size            = "Free"
}

resource "azurerm_static_site_custom_domain" "frontend_env" {
  static_site_id  = azurerm_static_site.frontend.id
  domain_name     = azurerm_static_site.frontend.default_host_name
  validation_type = "cname-delegation"
}