resource "azurerm_public_ip" "gw_pub_ip" {
  name                = "pip-${var.application_gateway_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  allocation_method   = "Static"
}

resource "azurerm_web_application_firewall_policy" "application_firewall_policy" {
  name                = "${var.application_gateway_name}-waf-policy"
  location            = var.location
  resource_group_name = var.resource_group_name
  policy_settings {
    enabled                     = true
    mode                        = "Prevention"
    request_body_check          = true
    file_upload_limit_in_mb     = 100
    max_request_body_size_in_kb = 128
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }
}


# -
# - Application Gateway
# -
resource "azurerm_application_gateway" "az_application_gateway" {
  name                = var.application_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name
  zones               = var.zones
  enable_http2        = var.enable_http2
  firewall_policy_id  = azurerm_web_application_firewall_policy.application_firewall_policy.id


  # Backend address pool config block
  dynamic "backend_address_pool" {
    for_each = var.backend_address_pool
    content {
      name         = lookup(backend_address_pool.value, "name", null)
      fqdns        = lookup(backend_address_pool.value, "fqdns", null)
      ip_addresses = lookup(backend_address_pool.value, "ip_addresses", null)
    }
  }

  # Backend http setttings config block
  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings
    content {
      affinity_cookie_name                = lookup(backend_http_settings.value, "affinity_cookie_name", "ApplicationGatewayAffinity")
      cookie_based_affinity               = lookup(backend_http_settings.value, "cookie_based_affinity", "Disabled")
      name                                = lookup(backend_http_settings.value, "name", null)
      path                                = lookup(backend_http_settings.value, "path", "")
      port                                = lookup(backend_http_settings.value, "port", 443)
      probe_name                          = lookup(backend_http_settings.value, "probe_name", null)
      protocol                            = lookup(backend_http_settings.value, "protocol", "Https")
      request_timeout                     = lookup(backend_http_settings.value, "request_timeout", 20)
      pick_host_name_from_backend_address = lookup(backend_http_settings.value, "pick_host_name_from_backend_address", false)
      host_name                           = lookup(backend_http_settings.value, "host_name", null)
      trusted_root_certificate_names      = lookup(backend_http_settings.value, "trusted_root_certificate_names", [])
      # authentication_certificate {
      #   name = lookup(backend_http_settings.value, "authentication_certificate_name", "")
      #   #data = lookup(backend_http_settings.value, "authentication_certificate_data", "")
      # }
      connection_draining {
        enabled           = lookup(backend_http_settings.value, "connection_draining_enabled", false)
        drain_timeout_sec = lookup(backend_http_settings.value, "connection_draining_drain_timeout_sec", 3600)
      }
    }
  }

  # Frontend ip configurations config block
  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configuration #? [true] : []
    content {
      name                          = lookup(frontend_ip_configuration.value, "name", null)
      subnet_id                     = lookup(frontend_ip_configuration.value, "subnet_id", null)
      private_ip_address_allocation = lookup(frontend_ip_configuration.value, "private_ip_address_allocation", null)
      public_ip_address_id          = azurerm_public_ip.gw_pub_ip.id
      private_ip_address            = lookup(frontend_ip_configuration.value, "private_ip_address", null)
    }
  }


  # Frontend port config block
  dynamic "frontend_port" {
    for_each = var.frontend_port
    content {
      name = lookup(frontend_port.value, "name", null)
      port = lookup(frontend_port.value, "port", null)
    }
  }

  # Gateway ip configuration block
  dynamic "gateway_ip_configuration" {
    for_each = var.gateway_ip_configurations
    content {
      name      = lookup(gateway_ip_configuration.value, "name", null)
      subnet_id = lookup(gateway_ip_configuration.value, "subnet_id", null)
    }
  }

  # HTTP listener config block
  dynamic "http_listener" {
    for_each = var.http_listener
    content {
      name                           = lookup(http_listener.value, "name", null)
      frontend_ip_configuration_name = lookup(http_listener.value, "frontend_ip_conf", null)
      frontend_port_name             = lookup(http_listener.value, "frontend_port_name", null)
      host_name                      = lookup(http_listener.value, "host_name", null)
      host_names                     = lookup(http_listener.value, "host_names", null)
      protocol                       = lookup(http_listener.value, "protocol", "Https")
      require_sni                    = lookup(http_listener.value, "require_sni", null)
      ssl_certificate_name           = lookup(http_listener.value, "ssl_certificate_name", null)
      firewall_policy_id             = azurerm_web_application_firewall_policy.application_firewall_policy.id
    }
  }


  # Identity config block
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.az_usr_identity.id]
  }


  # Request routing rule config block
  dynamic "request_routing_rule" {
    for_each = var.request_routing_rule
    content {
      name      = lookup(request_routing_rule.value, "name", null)
      rule_type = lookup(request_routing_rule.value, "rule_type", "Basic")

      http_listener_name          = lookup(request_routing_rule.value, "http_listener_name", lookup(request_routing_rule.value, "name", null))
      backend_address_pool_name   = lookup(request_routing_rule.value, "backend_address_pool_name", lookup(request_routing_rule.value, "name", null))
      backend_http_settings_name  = lookup(request_routing_rule.value, "backend_http_settings_name", lookup(request_routing_rule.value, "name", null))
      url_path_map_name           = lookup(request_routing_rule.value, "url_path_map_name", null)
      redirect_configuration_name = lookup(request_routing_rule.value, "redirect_configuration_name", null)
      rewrite_rule_set_name       = lookup(request_routing_rule.value, "rewrite_rule_set_name", null)
    }
  }

  # sku config block
  dynamic "sku" {
    for_each = var.sku
    content {
      name     = lookup(sku.value, "name", null)
      tier     = lookup(sku.value, "tier", null)
      capacity = lookup(sku.value, "capacity", null)
    }
  }


  # Trusted root certificate config block
  dynamic "trusted_root_certificate" {
    for_each = var.trusted_root_certificate_configs
    content {
      name = lookup(trusted_root_certificate.value, "name", null)
      data = filebase64(lookup(trusted_root_certificate.value, "data", null))
    }
  }

  # ssl policy config block
  dynamic "ssl_policy" {
    for_each = var.ssl_policy
    content {
      disabled_protocols   = lookup(ssl_policy.value, "disabled_protocols", [])
      policy_type          = lookup(ssl_policy.value, "policy_type", "Predefined")
      policy_name          = lookup(ssl_policy.value, "policy_name", "AppGwSslPolicy20170401S")
      cipher_suites        = lookup(ssl_policy.value, "cipher_suites", [])
      min_protocol_version = lookup(ssl_policy.value, "min_protocol_version", null)
    }
  }


  # Probe config block
  dynamic "probe" {
    for_each = var.probe
    content {
      host                                      = lookup(probe.value, "host", null)
      interval                                  = lookup(probe.value, "interval", 30)
      name                                      = lookup(probe.value, "name", null)
      protocol                                  = lookup(probe.value, "protocol", "Https")
      path                                      = lookup(probe.value, "path", "/")
      timeout                                   = lookup(probe.value, "timeout", 30)
      unhealthy_threshold                       = lookup(probe.value, "unhealthy_threshold", 3)
      port                                      = lookup(probe.value, "port", null)
      pick_host_name_from_backend_http_settings = lookup(probe.value, "pick_host_name_from_backend_http_settings", true)
      minimum_servers                           = lookup(probe.value, "minimum_servers", null)
      match {
        body        = lookup(probe.value, "match_body", "")
        status_code = lookup(probe.value, "match_status_code", ["200-399"])
      }
    }
  }


  # SSL certificate config block
  dynamic "ssl_certificate" {
    for_each = var.ssl_certificate
    content {
      name                = lookup(ssl_certificate.value, "name", null)
      data                = lookup(ssl_certificate.value, "data", null)
      password            = lookup(ssl_certificate.value, "password", null)
      key_vault_secret_id = lookup(ssl_certificate.value, "key_vault_secret_id", null)
    }
  }


  # URL path map and path_rule config block
  dynamic "url_path_map" {
    for_each = var.url_path_map
    content {
      name                                = lookup(url_path_map.value, "name", null)
      default_backend_address_pool_name   = lookup(url_path_map.value, "default_backend_address_pool_name", null)
      default_backend_http_settings_name  = lookup(url_path_map.value, "default_backend_http_settings_name", lookup(url_path_map.value, "default_backend_address_pool_name", null))
      default_redirect_configuration_name = lookup(url_path_map.value, "default_redirect_configuration_name", null)
      default_rewrite_rule_set_name       = lookup(url_path_map.value, "default_rewrite_rule_set_name", null)

      dynamic "path_rule" {
        for_each = lookup(url_path_map.value, "path_rule")
        content {
          name                        = lookup(path_rule.value, "path_rule_name", null)
          backend_address_pool_name   = lookup(path_rule.value, "backend_address_pool_name", lookup(path_rule.value, "path_rule_name", null))
          backend_http_settings_name  = lookup(path_rule.value, "backend_http_settings_name", lookup(path_rule.value, "path_rule_name", null))
          paths                       = [lookup(path_rule.value, "paths", null)]
          redirect_configuration_name = lookup(path_rule.value, "redirect_configuration_name", null)
          rewrite_rule_set_name       = lookup(path_rule.value, "rewrite_rule_set_name", null)
        }
      }
    }
  }

  # waf config block
  waf_configuration {
    enabled                  = coalesce(var.enable_waf, false)
    file_upload_limit_mb     = coalesce(var.file_upload_limit_mb, 100)
    firewall_mode            = coalesce(var.waf_mode, "Prevention")
    max_request_body_size_kb = coalesce(var.max_request_body_size_kb, 128)
    request_body_check       = var.request_body_check
    rule_set_type            = var.rule_set_type
    rule_set_version         = var.rule_set_version

    dynamic "disabled_rule_group" {
      for_each = var.disabled_rule_group_settings
      content {
        rule_group_name = lookup(disabled_rule_group.value, "rule_group_name", null)
        rules           = lookup(disabled_rule_group.value, "rules", null)
      }
    }

    dynamic "exclusion" {
      for_each = var.waf_exclusion_settings
      content {
        match_variable          = lookup(exclusion.value, "match_variable", null)
        selector                = lookup(exclusion.value, "selector", null)
        selector_match_operator = lookup(exclusion.value, "selector_match_operator", null)
      }
    }
  }

  # custom_error_configuration block
  dynamic "custom_error_configuration" {
    for_each = var.custom_error_configuration
    content {
      status_code           = lookup(custom_error_configuration.value, "status_code", null)
      custom_error_page_url = lookup(custom_error_configuration.value, "custom_error_page_url", null)
    }
  }


  # Redirect configuration block
  dynamic "redirect_configuration" {
    for_each = var.redirect_configuration
    content {
      name                 = lookup(redirect_configuration.value, "name", null)
      redirect_type        = lookup(redirect_configuration.value, "redirect_type", "Permanent")
      target_listener_name = lookup(redirect_configuration.value, "target_listener_name", null)
      target_url           = lookup(redirect_configuration.value, "target_url", null)
      include_path         = lookup(redirect_configuration.value, "include_path", "true")
      include_query_string = lookup(redirect_configuration.value, "include_query_string", "true")
    }
  }


  # autoscale_configuration block

  dynamic "autoscale_configuration" {
    for_each = var.autoscale_configuration
    content {
      min_capacity = var.autoscale_configuration.min_capacity
      max_capacity = var.autoscale_configuration.max_capacity
    }
  }


  # Rewrite rule set config block
  dynamic "rewrite_rule_set" {
    for_each = var.appgw_rewrite_rule_set
    content {
      name = lookup(rewrite_rule_set.value, "name", null)
      dynamic "rewrite_rule" {
        for_each = lookup(rewrite_rule_set.value, "rewrite_rule", null)
        content {
          name          = lookup(rewrite_rule.value, "name", null)
          rule_sequence = lookup(rewrite_rule.value, "rule_sequence", null)

          condition {
            ignore_case = lookup(rewrite_rule.value, "condition_ignore_case", null)
            negate      = lookup(rewrite_rule.value, "condition_negate", null)
            pattern     = lookup(rewrite_rule.value, "condition_pattern", null)
            variable    = lookup(rewrite_rule.value, "condition_variable", null)
          }

          request_header_configuration {
            header_name  = lookup(rewrite_rule.value, "response_header_name", null)
            header_value = lookup(rewrite_rule.value, "response_header_value", null)
          }

          response_header_configuration {
            header_name  = lookup(rewrite_rule.value, "response_header_name", null)
            header_value = lookup(rewrite_rule.value, "response_header_value", null)
          }
        }
      }
    }
  }


  tags = var.app_gateway_tags
}


# -
# - log analytics for appgw
# -
module "azure_diagnostic_setting" {
  source                  = "../../AzureMonitor/diagnostic_setting"
  count                   = var.enable_diagnostic_setting ? 1 : 0
  diagnostic_setting_name = "${var.application_gateway_name}-logs" #var.diagnostic_setting_name
  target_resource_id      = azurerm_application_gateway.az_application_gateway.id
  log_analytics_id        = var.logs_destinations_ids

  log = [
    {
      category = "ApplicationGatewayAccessLog"
    },
    {
      category = "ApplicationGatewayPerformanceLog"
    },
    {
      category = "ApplicationGatewayFirewallLog"
    }
  ]
  metric = [
    {
      category = "AllMetrics"
    }
  ]
  depends_on = [azurerm_application_gateway.az_application_gateway]
}

resource "azurerm_user_assigned_identity" "az_usr_identity" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = var.application_gateway_name
}

# -
# - Create Key Vault Accesss Policy for UserManagedIdentity
# -
resource "azurerm_key_vault_access_policy" "az_keyvault_usr_identity_policy" {
  key_vault_id = var.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.az_usr_identity.principal_id

  key_permissions         = ["get"]
  secret_permissions      = ["get"]
  certificate_permissions = ["get"]
  storage_permissions     = ["get"]

  depends_on = [azurerm_user_assigned_identity.az_usr_identity]
}

# -
# - Get the current user config
# -
data "azurerm_client_config" "current" {}