resource "azurerm_resource_group" "edge_resource_group" {
  name     = "EdgeResourceGroup"
  location = "East US"

  tags = {
    environment = "POC"
  }
}

resource "azurerm_resource_group" "landing_zone_resource_group" {
  name     = "LandingZoneResourceGroup"
  location = "East US"

  tags = {
    environment = "POC"
  }
}
