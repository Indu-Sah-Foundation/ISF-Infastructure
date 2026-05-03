resource "azurerm_storage_account" "storage" {
  name                     = "${replace(var.app_name, "-", "")}storage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = true

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}


resource "azurerm_storage_container" "images" {
  name                  = "images"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "blob"  
}

resource "azurerm_storage_container" "receipts" {
  name                  = "receipts"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}