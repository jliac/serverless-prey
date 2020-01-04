resource "azurerm_function_app" "functionApp" {
  name                      = "cougar${var.UniqueString}"
  location                  = var.ResourceGroupLocation
  resource_group_name       = azurerm_resource_group.cougar.name
  app_service_plan_id       = azurerm_app_service_plan.appServicePlan.id
  storage_connection_string = azurerm_storage_account.functionStorageAccount.primary_connection_string
  version                   = "beta"

  app_settings = {
      https_only = true
      FUNCTIONS_WORKER_RUNTIME = "dotnet"
  }

  provisioner "local-exec" {
    command = "cd ../src; func azure functionapp publish cougar${var.UniqueString} --csharp --force"
  }
}
