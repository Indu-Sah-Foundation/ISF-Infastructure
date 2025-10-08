output "webapp_url" {
    value = { for k, v in azurerm_linux_web_app.app: k => "https://${v.name}.azurewebsites.net"}
}