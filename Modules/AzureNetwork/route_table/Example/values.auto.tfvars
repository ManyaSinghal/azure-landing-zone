route_table_name = "test-rt"

routes = [{
  name           = "terraform-demo-route"
  address_prefix = "10.1.0.0/16"
  next_hop_type  = "None"
}]

create_route_filter = true

tags = {
  Name        = "terraform-demo-vent"
  Environment = "Dev"
}
