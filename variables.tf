variable "location" {
  description = "Azure region"
  default     = "East US"
  type        = string
}

variable "postgres_location" {
  description = "Azure region"
  default     = "West US"
  type        = string
}

variable "app_name" {
  description = "Base name for apps"
  default     = "isfapp"
  type        = string
}
 
variable "db_admin_username" {
  description = "PostgreSQL administrator username"
  type        = string
  default     = "pgadmin"
}

# Note: secrets (db_admin_password, jwt_secret, stripe_*, admin_password,
# translator_key) are NOT declared here. They live in Key Vault and are read
# at plan time via `data "azurerm_key_vault_secret"` blocks in keyvault.tf.

variable "developer_ip" {
  description = "Your public IP for DataGrip access – find it at https://ifconfig.me"
  type        = string
}

variable "admin_email" {
  description = "Initial admin user email -- bootstrapped on backend startup"
  type        = string
  default     = "admin@isf.org"
}

variable "donation_success_url" {
  description = "Where Stripe redirects after a successful donation"
  type        = string
  default     = "https://orange-desert-0d758fb0f.7.azurestaticapps.net/donate/thanks"
}

variable "donation_cancel_url" {
  description = "Where Stripe redirects after a cancelled donation"
  type        = string
  default     = "https://orange-desert-0d758fb0f.7.azurestaticapps.net/donate"
}

variable "port" {
  description = "Backend API port"
  type        = string
  default     = "8080"
}

variable "gin_mode" {
  description = "Gin framework mode (debug, release, test)"
  type        = string
  default     = "release"
}

variable "translator_endpoint" {
  description = "Azure Translator API endpoint"
  type        = string
  default     = "https://api.cognitive.microsofttranslator.com/"
}

variable "translator_region" {
  description = "Azure Translator region"
  type        = string
  default     = "eastus2"
}