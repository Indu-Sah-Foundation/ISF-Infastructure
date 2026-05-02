variable "location" {
  description = "Azure region"
  default     = "East US"
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