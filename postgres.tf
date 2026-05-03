resource "azurerm_postgresql_flexible_server" "db" {
  name                   = "${var.app_name}-postgres-west"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = "${var.postgres_location}"
  version                = "16"
  administrator_login    = var.db_admin_username
  administrator_password = var.db_admin_password
  sku_name               = "B_Standard_B1ms"
  storage_mb             = 32768
  backup_retention_days  = 7
}

resource "azurerm_postgresql_flexible_server_database" "app_db" {
  name      = "${var.app_name}db"
  server_id = azurerm_postgresql_flexible_server.db.id
  collation = "en_US.utf8"
  charset   = "utf8"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "azure_services" {
  name             = "allow-azure-services"
  server_id        = azurerm_postgresql_flexible_server.db.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "local_dev" {
  name             = "allow-local-dev"
  server_id        = azurerm_postgresql_flexible_server.db.id
  start_ip_address = var.developer_ip
  end_ip_address   = var.developer_ip

}