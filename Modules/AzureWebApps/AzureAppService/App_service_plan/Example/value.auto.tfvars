app_service_plan_tags = {
  Name        = "terraform-demo-vent"
  Environment = "Dev"
}

app_service_plan_name = "test-app-001"
app_service_plan_kind = "FunctionApp"

app_service_plan_sku = {
  tier     = "Premium V2 Small"
  size     = "P1V2"
  capacity = "1"
}