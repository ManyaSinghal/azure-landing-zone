
# -
# - Storage Account
# -
resource "azurerm_storage_account" "az_storage_account" {
  name                          = var.storage_account_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  account_kind                  = var.account_kind
  account_tier                  = var.account_tier
  account_replication_type      = var.account_replication_type
  access_tier                   = var.access_tier
  https_traffic_only_enabled    = var.enable_https_traffic_only
  min_tls_version               = var.min_tls_version
  public_network_access_enabled = var.public_network_access_enabled
  is_hns_enabled                = var.is_hns_enabled
  large_file_share_enabled      = var.large_file_share_enabled


  blob_properties {
    dynamic "cors_rule" {
      for_each = var.cors_rule
      content {
        allowed_origins    = lookup(cors_rule.value, "allowed_origins", null)
        allowed_methods    = lookup(cors_rule.value, "allowed_methods", null)
        allowed_headers    = lookup(cors_rule.value, "allowed_headers", null)
        exposed_headers    = lookup(cors_rule.value, "exposed_headers", null)
        max_age_in_seconds = lookup(cors_rule.value, "max_age_in_seconds", null)
      }
    }
  }

  dynamic "custom_domain" {
    for_each = var.custom_domain
    content {
      name          = lookup(custom_domain.value, "name", null)
      use_subdomain = lookup(custom_domain.value, "use_subdomain", null)
    }
  }

  identity {
    type = var.assign_identity ? "SystemAssigned" : null
  }

  dynamic "network_rules" {
    for_each = var.network_rules
    content {
      default_action             = lookup(network_rules.value, "default_action", null)
      bypass                     = lookup(network_rules.value, "bypass", null)
      ip_rules                   = lookup(network_rules.value, "ip_rules", null)
      virtual_network_subnet_ids = lookup(network_rules.value, "virtual_network_subnet_ids", null)
    }
  }

  dynamic "static_website" {
    for_each = var.static_website
    content {
      index_document     = lookup(static_website.value, "index_document", null)
      error_404_document = lookup(static_website.value, "error_404_document", null)
    }
  }

  dynamic "queue_properties" {
    for_each = var.queue_properties
    content {
      dynamic "cors_rule" {
        for_each = coalesce(queue_properties.value.cors_rule, [])
        content {
          allowed_headers    = coalesce(cors_rule.value.allowed_headers, [])
          allowed_methods    = coalesce(cors_rule.value.allowed_methods, [])
          allowed_origins    = coalesce(cors_rule.value.allowed_origins, [])
          exposed_headers    = coalesce(cors_rule.value.exposed_headers, [])
          max_age_in_seconds = coalesce(cors_rule.value.max_age_in_seconds, "")
        }
      }

      dynamic "logging" {
        for_each = coalesce(queue_properties.value.logging, [])
        content {
          delete                = coalesce(logging.value.delete, "")
          read                  = coalesce(logging.value.read, "")
          write                 = coalesce(logging.value.write, "")
          version               = coalesce(logging.value.version, "")
          retention_policy_days = coalesce(logging.value.retention_policy_days, "")
        }
      }

      dynamic "minute_metrics" {
        for_each = coalesce(queue_properties.value.minute_metrics, [])
        content {
          enabled               = coalesce(minute_metrics.value.enabled, false)
          version               = coalesce(minute_metrics.value.version, "")
          include_apis          = coalesce(minute_metrics.value.include_apis, "")
          retention_policy_days = coalesce(lminute_metricsogging.value.retention_policy_days, "")
        }
      }

      dynamic "hour_metrics" {
        for_each = coalesce(queue_properties.value.hour_metrics, [])
        content {
          enabled               = coalesce(hour_metrics.value.enabled, false)
          version               = coalesce(hour_metrics.value.version, "")
          include_apis          = coalesce(hour_metrics.value.include_apis, "")
          retention_policy_days = coalesce(hour_metrics.value.retention_policy_days, "")
        }
      }
    }
  }
  lifecycle {
    ignore_changes = [
      blob_properties
    ]
  }
  tags = var.storage_account_tags
}


# -
# - Storage Account lifecycle rules
# -
resource "azurerm_storage_management_policy" "az_storage_management_policy" {
  count              = var.add_lifecycle_rules ? 1 : 0
  storage_account_id = azurerm_storage_account.az_storage_account.id
  dynamic "rule" {
    for_each = var.lifcecycle_rules
    content {
      name    = rule.value.name
      enabled = rule.value.enabled
      filters {
        prefix_match = rule.value.prefix_match
        blob_types   = rule.value.blob_types
      }
      actions {
        base_blob {
          tier_to_cool_after_days_since_modification_greater_than    = rule.value.tier_to_cool_after_days_since_modification_greater_than
          tier_to_archive_after_days_since_modification_greater_than = rule.value.tier_to_archive_after_days_since_modification_greater_than
          delete_after_days_since_modification_greater_than          = rule.value.delete_after_days_since_modification_greater_than
        }
        snapshot {
          delete_after_days_since_creation_greater_than = rule.value.delete_snapshot_after_days_since_creation_greater_than
        }
      }
    }
  }
}

# -
# - Storage Advanced Threat Protection 
# -
resource "azurerm_advanced_threat_protection" "az_advanced_threat_protection" {
  target_resource_id = azurerm_storage_account.az_storage_account.id
  enabled            = var.enable_advanced_threat_protection
}


