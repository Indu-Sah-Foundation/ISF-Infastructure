provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "rg" {
    name = var.resource_group_name
    location = var.location
}

resource "azurerm_app_service_plan" "plan" {
    name = "${var.app_name}-${var.environment}"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    kind = "Linux"
    reserved = true 

    sku {
        tier = "Basic"
        size = "B1"
    }
}

resource "azurerm_linux_web_app" "app" {
    name = "${var.app_name}-${var.environment}"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    service_plan_id = azurerm_app_service_plan.plan.id 

    site_config {
        app_command_line = "npm start"
    }

    app_settings = {
        "WEBSITE_NODE_DEFAULT_VERSION" = "~20"
    }
}


