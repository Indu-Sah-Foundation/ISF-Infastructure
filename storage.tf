resource "azurerm_storage_account" "storage" {
  name                     = "${replace(var.app_name, "-", "")}storage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = true

  # Browser uploads to Blob via SAS need CORS. Allow the deployed frontend +
  # local dev origins. Add custom domain here when you set one up.
  blob_properties {
    cors_rule {
      allowed_origins = [
        "https://proud-plant-069ab5b0f.3.azurestaticapps.net",
        "http://localhost:5173",
        "http://localhost:3000",
        "http://localhost:8080",

      ]
      allowed_methods    = ["GET", "PUT", "OPTIONS", "HEAD"]
      allowed_headers    = ["*"]
      exposed_headers    = ["*"]
      max_age_in_seconds = 3600
    }
  }

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