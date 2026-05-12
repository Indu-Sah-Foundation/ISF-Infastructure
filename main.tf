terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "isfterraformstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_oidc             = true
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.app_name}-rg"
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = "${replace(var.app_name, "-", "")}acr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
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
  https_only          = true

  site_config {
    always_on = true

    application_stack {
      docker_registry_url      = "https://${azurerm_container_registry.acr.login_server}"
      docker_registry_username = azurerm_container_registry.acr.admin_username
      docker_registry_password = azurerm_container_registry.acr.admin_password
      docker_image_name        = "go-backend:latest"
    }

    cors {
      allowed_origins = [
        "https://${azurerm_static_web_app.frontend.default_host_name}",
        "http://localhost:5173", # Vite dev
        "http://localhost:3000", # CRA / Next dev
        "http://localhost:8080", # CRA / Next dev
      ]
      support_credentials = false
    }

    health_check_path = "/health"
  }

  app_settings = {
    "WEBSITES_PORT" = "8080"
    "PORT"          = "8080"
    "GIN_MODE"      = "release"

    "DOCKER_REGISTRY_SERVER_URL"      = "https://${azurerm_container_registry.acr.login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME" = azurerm_container_registry.acr.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD" = azurerm_container_registry.acr.admin_password

    "TRANSLATOR_ENDPOINT"  = azurerm_cognitive_account.translator.endpoint
    "TRANSLATOR_REGION"    = azurerm_cognitive_account.translator.location
    "ADMIN_EMAIL"          = var.admin_email
    "DONATION_SUCCESS_URL" = var.donation_success_url
    "DONATION_CANCEL_URL"  = var.donation_cancel_url

    "AZURE_STORAGE_CONNECTION_STRING"       = azurerm_storage_account.storage.primary_connection_string
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.appinsights.connection_string

    "JWT_SECRET"            = "@Microsoft.KeyVault(SecretUri=${data.azurerm_key_vault_secret.jwt_secret.id})"
    "STRIPE_SECRET_KEY"     = "@Microsoft.KeyVault(SecretUri=${data.azurerm_key_vault_secret.stripe_secret_key.id})"
    "STRIPE_WEBHOOK_SECRET" = "@Microsoft.KeyVault(SecretUri=${data.azurerm_key_vault_secret.stripe_webhook_secret.id})"
    "ADMIN_PASSWORD"        = "@Microsoft.KeyVault(SecretUri=${data.azurerm_key_vault_secret.admin_password.id})"
    "DATABASE_URL"          = "@Microsoft.KeyVault(SecretUri=${data.azurerm_key_vault_secret.database_url.id})"
    "REDIS_URL"             = "@Microsoft.KeyVault(SecretUri=${data.azurerm_key_vault_secret.redis_url.id})"
    "TRANSLATOR_KEY"        = "@Microsoft.KeyVault(SecretUri=${data.azurerm_key_vault_secret.translator_key.id})"
  }

  identity {
    type = "SystemAssigned"
  }

  logs {
    application_logs {
      file_system_level = "Information"
    }
    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }
  }

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_static_web_app" "frontend" {
  name                = "${var.app_name}-react-frontend"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "eastus2"
  sku_tier            = "Free"
  sku_size            = "Free"
}


