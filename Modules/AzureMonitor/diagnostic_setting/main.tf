locals {
  logs_destinations_ids = var.logs_destinations_ids == null ? [] : var.logs_destinations_ids
  enabled               = length(local.logs_destinations_ids) > 0

  storage_id       = coalescelist([for r in local.logs_destinations_ids : r if contains(split("/", lower(r)), "microsoft.storage")], [null])[0]
  log_analytics_id = coalescelist([for r in local.logs_destinations_ids : r if contains(split("/", lower(r)), "microsoft.operationalinsights")], [null])[0]
  eventhub_id      = coalescelist([for r in local.logs_destinations_ids : r if contains(split("/", lower(r)), "microsoft.eventhub")], [null])[0]

  log_analytics_destination_type = local.log_analytics_id != null ? var.log_analytics_destination_type : null
}

# -
# - Azure monitor diagnostic setting
# -
resource "azurerm_monitor_diagnostic_setting" "az_monitor_diagnostic_setting" {
  count = local.enabled ? 1 : 0

  name               = var.diagnostic_setting_name
  target_resource_id = var.target_resource_id

  storage_account_id             = local.storage_id
  log_analytics_workspace_id     = local.log_analytics_id
  log_analytics_destination_type = local.log_analytics_destination_type
  eventhub_authorization_rule_id = local.eventhub_id

  # log config block
  dynamic "enabled_log" {
    for_each = var.log
    content {
      category = lookup(enabled_log.value, "category", null)

    }
  }

  # metric config block
  dynamic "metric" {
    for_each = var.metric
    content {
      category = lookup(enabled_metric.value, "category", "AllMetrics")
      enabled = true
    }
  }
}

