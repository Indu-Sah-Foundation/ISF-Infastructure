resource "azurerm_redis_cache" "cache" {
    name                = "${var.app_name}-redis"
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    capacity            = 0  
    family              = "C"
    sku_name            = "Basic"
    enable_non_ssl_port = true
    minimum_tls_version = "1.2"
    redis_configuration {
        maxmemory_policy = "allkeys-lru"
    }
    tags = {
        Environment = "Production"
        ManagedBy   = "Terraform"
    }

}