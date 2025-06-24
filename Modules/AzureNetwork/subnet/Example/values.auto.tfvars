subnet_name = "test-subnet"

subnet_address_prefix = ["172.21.2.0/24"]
service_endpoints     = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.Web"]
subnet_delegation = {
  app-service-plan = [
    {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  ]
}

create_subnet_nsg_association = false

