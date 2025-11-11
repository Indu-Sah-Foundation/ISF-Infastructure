# Import existing resources if they were created outside Terraform
# Remove this file after first successful apply

import {
  to = azurerm_resource_group.rg
  id = "/subscriptions/e00ac8d0-d7ed-48ef-9463-cc5138d2a3db/resourceGroups/isfinfa-rg"
}

import {
  to = azurerm_service_plan.asp
  id = "/subscriptions/e00ac8d0-d7ed-48ef-9463-cc5138d2a3db/resourceGroups/isfinfa-rg/providers/Microsoft.Web/serverFarms/isfinfa-plan"
}

import {
  to = azurerm_linux_web_app.backend
  id = "/subscriptions/e00ac8d0-d7ed-48ef-9463-cc5138d2a3db/resourceGroups/isfinfa-rg/providers/Microsoft.Web/sites/isfinfa-go-backend"
}
