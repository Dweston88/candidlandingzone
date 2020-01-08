resource "azurerm_virtual_network" "edge_vnet" {
  name                = "EdgeVirtualNetwork"
  address_space       = ["10.1.0.0/24"]
  location            = "${azurerm_resource_group.edge_resource_group.location}"
  resource_group_name = "${azurerm_resource_group.edge_resource_group.name}"
}

resource "azurerm_subnet" "edge_gateway_subnet" {
  # name required to be "GatewaySubnet" to be used by gateway"
  name                 = "GatewaySubnet"
  resource_group_name  = "${azurerm_resource_group.edge_resource_group.name}"
  virtual_network_name = "${azurerm_virtual_network.edge_vnet.name}"
  address_prefix       = "10.1.0.0/24"
}

resource "azurerm_public_ip" "edge_ip" {
  name                = "EdgePublicIp"
  location            = "${azurerm_resource_group.edge_resource_group.location}"
  resource_group_name = "${azurerm_resource_group.edge_resource_group.name}"

  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "edge_vnet_gateway" {
  name                = "EdgeGateway"
  location            = "${azurerm_resource_group.edge_resource_group.location}"
  resource_group_name = "${azurerm_resource_group.edge_resource_group.name}"

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    name                          = "EdgeVnetGatewayConfig"
    public_ip_address_id          = "${azurerm_public_ip.edge_ip.id}"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${azurerm_subnet.edge_gateway_subnet.id}"
  }
}