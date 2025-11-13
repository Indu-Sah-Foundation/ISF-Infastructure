import {
  to = azurerm_resource_group.state
  id = "/subscriptions/e00ac8d0-d7ed-48ef-9463-cc5138d2a3db/resourceGroups/terraform-state-rg"
}

import {
  to = azurerm_storage_account.state
  id = "/subscriptions/e00ac8d0-d7ed-48ef-9463-cc5138d2a3db/resourceGroups/terraform-state-rg/providers/Microsoft.Storage/storageAccounts/isfterraformstate"
}

import {
  to = azurerm_storage_container.state
  id = "https://isfterraformstate.blob.core.windows.net/tfstate"
}
