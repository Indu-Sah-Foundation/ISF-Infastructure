output "frontend_url" {
  value       = "https://${azurerm_static_site.frontend.default_host_name}"
  description = "React app URL"
}

output "backend_url" {
  value       = "https://${azurerm_linux_web_app.backend.default_hostname}"
  description = "Go API URL"
}

output "static_web_app_name" {
  value       = azurerm_static_site.frontend.name
  description = "For deployment token"
}

output "app_service_name" {
  value       = azurerm_linux_web_app.backend.name
  description = "For publish profile"
}