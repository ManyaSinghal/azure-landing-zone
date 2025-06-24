# -
# -  App
# -
resource "azurerm_windows_web_app" "az_app_service" {
  name                               = var.app_service_name
  location                           = var.location
  resource_group_name                = var.resource_group_name
  service_plan_id                    = var.app_service_plan_id
  client_certificate_enabled         = var.client_certificate_enabled
  client_certificate_mode            = var.client_certificate_mode
  client_certificate_exclusion_paths = var.client_certificate_exclusion_paths
  app_settings                       = var.app_settings
  enabled                            = var.enabled
  https_only                         = var.https_only
  key_vault_reference_identity_id    = var.key_vault_reference_identity_id
  virtual_network_subnet_id          = var.virtual_network_subnet_id
  tags                               = var.app_service_tags

  # logs config block
  dynamic "logs" {
    for_each = var.logs
    content {
      dynamic "application_logs" {
        for_each = coalesce(logs.value.application_logs, [])
        content {
          file_system_level = coalesce(application_logs.value.file_system_level, null)
          dynamic "azure_blob_storage" {
            for_each = coalesce(application_logs.value.azure_blob_storage, [])
            content {
              level             = coalesce(azure_blob_storage.value.level, null)
              sas_url           = coalesce(azure_blob_storage.value.sas_url, null)
              retention_in_days = coalesce(azure_blob_storage.value.retention_in_days, null)
            }
          }
        }
      }
      dynamic "http_logs" {
        for_each = coalesce(logs.value.http_logs, [])
        content {
          dynamic "file_system" {
            for_each = coalesce(http_logs.value.file_system, [])
            content {
              retention_in_days = coalesce(file_system.value.retention_in_days, null)
              retention_in_mb   = coalesce(file_system.value.retention_in_mb, null)
            }
          }
          dynamic "azure_blob_storage" {
            for_each = coalesce(http_logs.value.azure_blob_storage, [])
            content {
              sas_url           = lookup(azure_blob_storage.value.sas_url, null)
              retention_in_days = lookup(azure_blob_storage.value.retention_in_days, null)
            }
          }
        }
      }
    }
  }
  # identity config block
  identity {
    type = var.identity_type
  }

  dynamic "storage_account" {
    for_each = var.storage_account
    content {
      access_key   = lookup(storage_account.value, "access_key", null)
      account_name = lookup(storage_account.value, "account_name", null)
      name         = lookup(storage_account.value, "name", null)
      share_name   = lookup(storage_account.value, "share_name", false)
      type         = lookup(storage_account.value, "type", null)
      mount_path   = lookup(storage_account.value, "mount_path", null)
    }
  }

  dynamic "sticky_settings" {
    for_each = var.sticky_settings
    content {
      app_setting_names       = lookup(sticky_settings.value, "app_setting_names", null)
      connection_string_names = lookup(sticky_settings.value, "connection_string_names", null)
    }
  }
  # connection_string config block
  dynamic "connection_string" {
    for_each = var.connection_string
    content {
      name  = connection_string.value["name"]
      type  = connection_string.value["type"]
      value = connection_string.value["value"]
    }
  }

  # string config block
  site_config {
    always_on                                     = lookup(var.site_config, "always_on", true)
    api_definition_url                            = lookup(var.site_config, "api_definition_url", null)
    api_management_api_id                         = lookup(var.site_config, "api_management_api_id", null)
    app_command_line                              = lookup(var.site_config, "app_command_line", null)
    container_registry_managed_identity_client_id = lookup(var.site_config, "container_registry_managed_identity_client_id", null)
    container_registry_use_managed_identity       = lookup(var.site_config, "container_registry_use_managed_identity", false)
    default_documents                             = lookup(var.site_config, "default_documents", [])
    health_check_eviction_time_in_min             = lookup(var.site_config, "health_check_eviction_time_in_min", null)
    load_balancing_mode                           = lookup(var.site_config, "load_balancing_mode", null)
    managed_pipeline_mode                         = lookup(var.site_config, "managed_pipeline_mode", null)
    remote_debugging_enabled                      = lookup(var.site_config, "remote_debugging_enabled", false)
    remote_debugging_version                      = lookup(var.site_config, "remote_debugging_version", null)
    dynamic "application_stack" {
      for_each = lookup(var.site_config, "application_stack", {})
      content {
        current_stack                = lookup(application_stack.value, "current_stack", null)
        docker_image_name            = lookup(application_stack.value, "docker_image_name", null)
        docker_registry_url          = lookup(application_stack.value, "docker_registry_url", null)
        docker_registry_username     = lookup(application_stack.value, "docker_registry_username", null)
        docker_registry_password     = lookup(application_stack.value, "docker_registry_password", null)
        tomcat_version               = lookup(application_stack.value, "tomcat_version", null)
        java_embedded_server_enabled = lookup(application_stack.value, "java_embedded_server_enabled", null)
        php_version                  = lookup(application_stack.value, "php_version", null)
        dotnet_core_version          = lookup(application_stack.value, "dotnet_core_version", null)
        dotnet_version               = lookup(application_stack.value, "dotnet_version", null)
        java_version                 = lookup(application_stack.value, "java_version", null)
        node_version                 = lookup(application_stack.value, "node_version", null)
        python                       = lookup(application_stack.value, "python_version", null)
      }
    }

    ftps_state                  = lookup(var.site_config, "ftps_state", null)
    health_check_path           = lookup(var.site_config, "health_check_path", null)
    http2_enabled               = lookup(var.site_config, "health_check_path", null)
    minimum_tls_version         = lookup(var.site_config, "minimum_tls_version", null)
    scm_use_main_ip_restriction = lookup(var.site_config, "scm_use_main_ip_restriction", false)
    use_32_bit_worker           = lookup(var.site_config, "use_32_bit_worker", null)
    scm_minimum_tls_version     = lookup(var.site_config, "scm_minimum_tls_version", null)
    websockets_enabled          = lookup(var.site_config, "websockets_enabled", false)
    worker_count                = lookup(var.site_config, "worker_count", 1)

    vnet_route_all_enabled = lookup(var.site_config, "vnet_route_all_enabled", null)

    # cors config block
    dynamic "cors" {
      for_each = var.cors
      content {
        allowed_origins     = lookup(cors.value, "allowed_origins", null)
        support_credentials = lookup(cors.value, "support_credentials", null)
      }
    }

    # ip_restriction config block
    dynamic "ip_restriction" {
      for_each = var.ip_restriction
      content {
        ip_address                = lookup(ip_restriction.value, "ip_address", null)
        virtual_network_subnet_id = lookup(ip_restriction.value, "virtual_network_subnet_id", null)
      }
    }

    # scm_ip_restriction config block
    dynamic "scm_ip_restriction" {
      for_each = var.scm_ip_restriction
      content {
        ip_address                = lookup(scm_ip_restriction.value, "ip_address", null)
        virtual_network_subnet_id = lookup(scm_ip_restriction.value, "virtual_network_subnet_id", null)
        name                      = lookup(scm_ip_restriction.value, "name", null)
        priority                  = lookup(scm_ip_restriction.value, "priority", null)
        action                    = lookup(scm_ip_restriction.value, "action", null)
      }
    }
  }

  # source_control config block
  # dynamic "source_control" {
  #   for_each = var.source_control
  #   content {
  #     repo_url           = lookup(var.source_control, "repo_url", null)
  #     branch             = lookup(var.source_control, "branch", null)
  #     manual_integration = lookup(var.source_control, "manual_integration", null)
  #     rollback_enabled   = lookup(var.source_control, "rollback_enabled", null)
  #     use_mercurial      = lookup(var.source_control, "use_mercurial", null)
  #   }
  # }


  # auth_settings config block
  dynamic "auth_settings" {
    for_each = var.auth_settings
    content {
      enabled                        = lookup(auth_settings.value, "enabled", false)
      additional_login_parameters    = lookup(auth_settings.value, "additional_login_parameters", null)
      allowed_external_redirect_urls = lookup(auth_settings.value, "allowed_external_redirect_urls", null)
      default_provider               = lookup(auth_settings.value, "default_provider", null)
      token_store_enabled            = lookup(auth_settings.value, "token_store_enabled", null)
      unauthenticated_client_action  = lookup(auth_settings.value, "unauthenticated_client_action", null)
      issuer                         = lookup(auth_settings.value, "issuer", null)
      runtime_version                = lookup(auth_settings.value, "runtime_version", null)
      token_refresh_extension_hours  = lookup(auth_settings.value, "token_refresh_extension_hours", null)
    }
  }
}
