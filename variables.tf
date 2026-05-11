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

variable "db_admin_password" {
  description = "PostgreSQL administrator password"
  type        = string
  sensitive   = true
}

variable "developer_ip" {
  description = "Your public IP for DataGrip access – find it at https://ifconfig.me"
  type        = string
}

variable "translator_key" {
  description = "Azure Translator API key"
  type        = string
  sensitive   = true
}

variable "jwt_secret" {
  description = "HMAC secret used to sign JWTs. Generate via: openssl rand -base64 64 | tr -d '\\n'"
  type        = string
  sensitive   = true
}

variable "stripe_secret_key" {
  description = "Stripe API secret key (sk_test_... or sk_live_...)"
  type        = string
  sensitive   = true
}

variable "stripe_webhook_secret" {
  description = "Stripe webhook signing secret (whsec_...) for /donations/webhook"
  type        = string
  sensitive   = true
}

variable "admin_email" {
  description = "Initial admin user email -- bootstrapped on backend startup"
  type        = string
  default     = "admin@isf.org"
}

variable "admin_password" {
  description = "Initial admin user password -- ROTATE after first login"
  type        = string
  sensitive   = true
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