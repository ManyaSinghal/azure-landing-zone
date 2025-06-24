network_security_group_name = "test-nic"


nsg_tags = {
  Name        = "terraform-demo-vent"
  Environment = "Dev"
}

nsg_rules = [
  {
    name                   = "myssh"
    priority               = 201
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "tcp"
    source_port_range      = "*"
    destination_port_range = "22"
    source_address_prefix  = "10.151.0.0/24"
    description            = "description-myssh"
  },
  {
    name                    = "myhttp"
    priority                = 200
    direction               = "Inbound"
    access                  = "Allow"
    protocol                = "tcp"
    source_port_range       = "*"
    destination_port_range  = "8080"
    source_address_prefixes = ["10.151.0.0/24", "10.151.1.0/24"]
    description             = "description-http"
  },
]
