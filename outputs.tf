output "frontend_url" {
  value       = "https://${azurerm_static_web_app.frontend.default_host_name}"
  description = "React app URL"
}

output "backend_url" {
  value       = "https://${azurerm_linux_web_app.backend.default_hostname}"
  description = "Go API URL"
}

output "backend_api_url_for_react" {
  value       = "https://${azurerm_linux_web_app.backend.default_hostname}"
  description = "Use this URL in your React app as REACT_APP_API_URL"
}

output "static_web_app_name" {
  value       = azurerm_static_web_app.frontend.name
  description = "For deployment token"
}

output "static_web_app_api_key" {
  value       = azurerm_static_web_app.frontend.api_key
  description = "Deployment token for Static Web App"
  sensitive   = true
}

output "app_service_name" {
  value       = azurerm_linux_web_app.backend.name
  description = "For publish profile"
}

output "frontdoor_endpoint_url" {
  value       = "https://${azurerm_cdn_frontdoor_endpoint.main.host_name}"
  description = "Public Front Door URL – use this as your app's entry point"
}

output "frontdoor_endpoint_hostname" {
  value       = azurerm_cdn_frontdoor_endpoint.main.host_name
  description = "Raw Front Door hostname (for DNS CNAME if adding a custom domain)"
}

output "postgres_server_fqdn" {
  value = azurerm_postgresql_flexible_server.db.fqdn
}

output "postgres_database_name" {
  value = azurerm_postgresql_flexible_server_database.app_db.name
}

output "translator_endpoint" {
  value = azurerm_cognitive_account.translator.endpoint
  description = "Translator API endpoint"
}

output "translator_key" {
  value = azurerm_cognitive_account.translator.primary_access_key
  description = "Translator API key"
  sensitive = true
}

output "translator_region" {
  value = azurerm_cognitive_account.translator.location
  description = "Translator region"
}

output "redis_hostname" {
  value       = azurerm_redis_cache.cache.hostname
  description = "Redis hostname"
}

output "redis_port" {
  value       = azurerm_redis_cache.cache.ssl_port
  description = "Redis SSL port"
}

output "redis_primary_key" {
  value       = azurerm_redis_cache.cache.primary_access_key
  description = "Redis primary access key"
  sensitive   = true
}

output "keyvault_uri" {
  value       = azurerm_key_vault.kv.vault_uri
  description = "Key Vault URI"
}

output "storage_connection_string" {
  value       = azurerm_storage_account.storage.primary_connection_string
  sensitive   = true
}

output "images_url" {
  value       = "https://${azurerm_storage_account.storage.name}.blob.core.windows.net/images"
}