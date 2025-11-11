variable "location" {
  description = "Azure region"
  default     = "East US"
  type        = string
}

variable "app_name" {
  description = "Base name for apps"
  default     = "isf"
  type        = string
}