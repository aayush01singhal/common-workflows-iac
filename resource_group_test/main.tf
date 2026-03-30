resource "azurerm_resource_group" "test_resource_group_block" {
  for_each = var.resource_group
  name     = each.value.resource_group_name
  location = each.value.resource_group_location
}