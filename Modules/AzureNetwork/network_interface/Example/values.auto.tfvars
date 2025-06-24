network_interface_name = "test-nic"


tags = {
  Name        = "terraform-demo-vent"
  Environment = "Dev"
}

ip_configuration = [
  {
    name                          = "ipconfig1"
    subnet_id                     = "/subscriptions/7c3c220d-7c78-4f67-96f3-7a38317a906d/resourceGroups/test-rg-manya/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/default"
    public_ip_address_id          = null
    private_ip_address_allocation = "Dynamic"
    private_ip_address            = null
    primary                       = null
  }
]
