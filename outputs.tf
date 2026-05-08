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


output "postgres_server_fqdn" {
  value = azurerm_postgresql_flexible_server.db.fqdn
}

output "postgres_database_name" {
  value = azurerm_postgresql_flexible_server_database.app_db.name
}

output "postgres_admin_username" {
  value       = var.db_admin_username
  description = "PostgreSQL admin username"
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

output "keyvault_name" {
  value       = azurerm_key_vault.kv.name
  description = "Key Vault name"
}

output "storage_connection_string" {
  value       = azurerm_storage_account.storage.primary_connection_string
  sensitive   = true
}

output "storage_account_name" {
  value       = azurerm_storage_account.storage.name
  description = "Storage account name"
}

output "images_url" {
  value       = "https://${azurerm_storage_account.storage.name}.blob.core.windows.net/images"
}

output "appinsights_connection_string" {
  value       = azurerm_application_insights.appinsights.connection_string
  sensitive   = true
}