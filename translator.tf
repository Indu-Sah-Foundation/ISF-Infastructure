resource "azurerm_cognitive_account" "translator" {
    name = "${var.app_name}-translator"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    kind = "TextTranslation"
    sku_name = "F0"

    tag = {
        Environment = "Production"
        ManagedBy = "Terraform"
    }
}