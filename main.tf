provider "azurerm" {
    features {}
    subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rg" {
    for_each = var.env
    name = each.value.resource_group_name
    location = each.value.location
}

resource "azurerm_app_service_plan" "plan" {
    for_each = azurerm_resource_group.rg
    name = "${var.app_name}-${each.key}"
    location = each.value.location
    resource_group_name = each.value.name
    kind = "Linux"
    reserved = true 

    sku {
        tier = "Basic"
        size = "B1"
    }
}

resource "azurerm_linux_web_app" "app" {
    for_each = azurerm_app_service_plan.plan
    name = "${var.app_name}-${each.key}"
    resource_group_name = azurerm_resource_group.rg[each.key].name
    location = azurerm_resource_group.rg[each.key].location
    service_plan_id = each.value.id

    site_config {
        app_command_line = "npm start"
    }

    app_settings = {
        "WEBSITE_NODE_DEFAULT_VERSION" = "~20"
    }
}



