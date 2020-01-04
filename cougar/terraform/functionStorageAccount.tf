resource "azurerm_storage_account" "functionStorageAccount" {
  name                     = "cougar${var.UniqueString}"
  location                 = var.ResourceGroupLocation
  resource_group_name      = azurerm_resource_group.cougar.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
