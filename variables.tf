

variable "app_name" {
    description = "Name of the application"
    type = string

}


variable "subscription_id" {
    description = "Azure Subscription ID"
    type = string
}

variable "env" {
    type = map(object({
        resource_group_name = string
        location            = string
    }))
    description = "Map of environemnt -> { resource_group_name, location }"
}