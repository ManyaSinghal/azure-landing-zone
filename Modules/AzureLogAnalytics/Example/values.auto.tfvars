prefix                      = "test-monla"
log_analytics_workspace_sku = "PerGB2018"
tags = {
  Name        = "terraform-demo-vent"
  Environment = "Dev"
}

enable_log_analytics_workspace = true
log_solution_name              = "ContainerInsights"
plan = {
  plan1 = {
    publisher      = "Microsoft"
    product        = "OMSGallery/ContainerInsights"
    promotion_code = null
  }
}