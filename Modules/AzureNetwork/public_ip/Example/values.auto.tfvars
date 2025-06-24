public_ip_name = "test-pip"
ip_address = {
  ipaddress1 = {
    allocation_method = "Static"
    sku               = "Standard"
    ip_version        = "IPv4"
    timeout           = 15
    zones             = [1]
  }
}


tags = {
  Name        = "terraform-demo-vent"
  Environment = "Dev"
}
