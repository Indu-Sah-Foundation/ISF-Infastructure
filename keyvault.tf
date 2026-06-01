data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                = "${var.app_name}-kv"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
variable "developer_object_id" {
  description = "Object ID of YOUR Azure user account (az ad signed-in-user show --query id -o tsv)"
  type        = string
}

resource "azurerm_key_vault_access_policy" "developer" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.developer_object_id   # pinned, doesn't flip per-applier

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Purge",
    "Recover",
  ]
}

# @Microsoft.KeyVault references in app_settings.
resource "azurerm_key_vault_access_policy" "app_service" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_web_app.backend.identity[0].principal_id

  secret_permissions = [
    "Get",
    "List",
  ]
}

# GitHub Actions service principal needs Get/List to read secret URIs at plan time.
variable "github_actions_sp_object_id" {
  description = "Object ID of the SP backing GitHub Actions OIDC"
  type        = string
}

resource "azurerm_key_vault_access_policy" "github_actions" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.github_actions_sp_object_id

  secret_permissions = [
    "Get",
    "List",
  ]
}

data "azurerm_key_vault_secret" "jwt_secret" {
  name         = "jwt-secret"
  key_vault_id = azurerm_key_vault.kv.id
  depends_on = [
    azurerm_key_vault_access_policy.developer,
    azurerm_key_vault_access_policy.github_actions,
  ]
}

data "azurerm_key_vault_secret" "stripe_secret_key" {
  name         = "stripe-secret-key"
  key_vault_id = azurerm_key_vault.kv.id
  depends_on = [
    azurerm_key_vault_access_policy.developer,
    azurerm_key_vault_access_policy.github_actions,
  ]
}

data "azurerm_key_vault_secret" "stripe_webhook_secret" {
  name         = "stripe-webhook-secret"
  key_vault_id = azurerm_key_vault.kv.id
  depends_on = [
    azurerm_key_vault_access_policy.developer,
    azurerm_key_vault_access_policy.github_actions,
  ]
}

data "azurerm_key_vault_secret" "admin_password" {
  name         = "admin-password"
  key_vault_id = azurerm_key_vault.kv.id
  depends_on = [
    azurerm_key_vault_access_policy.developer,
    azurerm_key_vault_access_policy.github_actions,
  ]
}

data "azurerm_key_vault_secret" "database_url" {
  name         = "database-url"
  key_vault_id = azurerm_key_vault.kv.id
  depends_on = [
    azurerm_key_vault_access_policy.developer,
    azurerm_key_vault_access_policy.github_actions,
  ]
}

data "azurerm_key_vault_secret" "redis_url" {
  name         = "redis-url"
  key_vault_id = azurerm_key_vault.kv.id
  depends_on = [
    azurerm_key_vault_access_policy.developer,
    azurerm_key_vault_access_policy.github_actions,
  ]
}

data "azurerm_key_vault_secret" "translator_key" {
  name         = "translator-key"
  key_vault_id = azurerm_key_vault.kv.id
  depends_on = [
    azurerm_key_vault_access_policy.developer,
    azurerm_key_vault_access_policy.github_actions,
  ]
}

data "azurerm_key_vault_secret" "db_admin_password" {
  name         = "db-admin-password"
  key_vault_id = azurerm_key_vault.kv.id
  depends_on = [
    azurerm_key_vault_access_policy.developer,
    azurerm_key_vault_access_policy.github_actions,
  ]
}

data "azurerm_key_vault_secret" "api_key" {
  name         = "api-key"
  key_vault_id = azurerm_key_vault.kv.id
  depends_on = [
    azurerm_key_vault_access_policy.developer,
    azurerm_key_vault_access_policy.github_actions,
  ]
}

data "azurerm_key_vault_secret" "github_token" {
  name         = "github-token"
  key_vault_id = azurerm_key_vault.kv.id
  depends_on = [
    azurerm_key_vault_access_policy.developer,
    azurerm_key_vault_access_policy.github_actions,
  ]
}
