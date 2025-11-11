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
