variable "resource_group" {
  description = "A map of resource groups"
  type = map(object({
    resource_group_name     = string
    resource_group_location = string
  }))
}
