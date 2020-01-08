resource "azurerm_virtual_network" "landing_zone_vnet" {
  name                = "LandingZoneVirtualNetwork"
  address_space       = ["10.2.0.0/24"]
  location            = "${azurerm_resource_group.landing_zone_resource_group.location}"
  resource_group_name = "${azurerm_resource_group.landing_zone_resource_group.name}"
}

resource "azurerm_subnet" "landing_zone_gateway_subnet" {
  # name required to be "GatewaySubnet" to be used by gateway"
  name                 = "GatewaySubnet"
  resource_group_name  = "${azurerm_resource_group.landing_zone_resource_group.name}"
  virtual_network_name = "${azurerm_virtual_network.landing_zone_vnet.name}"
  address_prefix       = "10.2.0.0/24"
}

resource "azurerm_public_ip" "landing_zone_ip" {
  name                = "LandingZonePublicIp"
  location            = "${azurerm_resource_group.landing_zone_resource_group.location}"
  resource_group_name = "${azurerm_resource_group.landing_zone_resource_group.name}"

  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "landing_zone_vnet_gateway" {
  name                = "LandingZoneGateway"
  location            = "${azurerm_resource_group.landing_zone_resource_group.location}"
  resource_group_name = "${azurerm_resource_group.landing_zone_resource_group.name}"

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    name                          = "LandingZoneVnetGatewayConfig"
    public_ip_address_id          = "${azurerm_public_ip.landing_zone_ip.id}"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${azurerm_subnet.landing_zone_gateway_subnet.id}"
  }
}