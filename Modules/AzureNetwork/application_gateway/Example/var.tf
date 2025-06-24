variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Application Gateway component."
}

variable "additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
}

variable "application_gateways" {
  type = map(object({
    name    = string
    zones   = list(string)
    waf_key = string
    sku = object({
      name     = string
      tier     = string
      capacity = number
    })
    gateway_ip_configurations = list(object({
      name        = string
      subnet_name = string
    }))
    frontend_ports = list(object({
      name = string
      port = number
    }))
    frontend_ip_configurations = list(object({
      name             = string
      subnet_name      = string
      static_ip        = string
      enable_public_ip = bool
    }))
    backend_address_pools = list(object({
      name         = string
      fqdns        = list(string)
      ip_addresses = list(string)
    }))
    backend_http_settings = list(object({
      name                  = string
      cookie_based_affinity = string
      path                  = string
      port                  = number
      request_timeout       = number
      probe_name            = string
      host_name             = string
    }))
    http_listeners = list(object({
      name                           = string
      frontend_ip_configuration_name = string
      frontend_port_name             = string
      ssl_certificate_name           = string
      sni_required                   = bool
      listener_type                  = string # MultiSite or Basic
      host_name                      = string # Required if listener_type = MultiSite
    }))
    request_routing_rules = list(object({
      name                        = string
      rule_type                   = string
      listener_name               = string
      backend_address_pool_name   = string
      backend_http_settings_name  = string
      redirect_configuration_name = string
      url_path_map_name           = string
    }))
    url_path_maps = list(object({
      name                                = string
      default_backend_http_settings_name  = string
      default_backend_address_pool_name   = string
      default_redirect_configuration_name = string
      path_rules = list(object({
        name                        = string
        paths                       = list(string)
        backend_http_settings_name  = string
        backend_address_pool_name   = string
        redirect_configuration_name = string
      }))
    }))
    probes = list(object({
      name                = string
      path                = string
      host                = string
      interval            = number
      timeout             = number
      unhealthy_threshold = number
    }))
    redirect_configuration = object({
      name                 = string
      redirect_type        = string
      target_listener_name = string
      target_url           = string
      include_path         = bool
      include_query_string = bool
    })
    ssl_certificate_name     = string
    ssl_certificate_path     = string
    ssl_certificate_password = string
    disabled_ssl_protocols   = list(string)
  }))
  description = "Map containing Application Gateways details"
}

variable "waf_policies" {
  type = map(object({
    name = string
    custom_rules = list(object({
      name      = string
      priority  = number
      rule_type = string
      action    = string
      match_conditions = list(object({
        match_variables = list(object({
          variable_name = string
          selector      = string
        }))
        operator           = string
        negation_condition = bool
        match_values       = list(string)
      }))
    }))
    policy_settings = object({
      enabled = bool
      mode    = string
    })
    managed_rules = object({
      exclusions = list(object({
        match_variable          = string
        selector                = string
        selector_match_operator = string
      }))
      managed_rule_sets = list(object({
        type    = string
        version = string
        rule_group_overrides = list(object({
          rule_group_name = string
          disabled_rules  = list(string)
        }))
      }))
    })
  }))
  description = "Map containing Web Application Firewall details"
}

variable "subnet_ids" {
  type        = map(string)
  description = "A map of subnet id's"
}

variable "key_vault_resource_group" {
  type        = string
  description = "Specifies the Resource Group name where source Key Vault exists"
}

variable "key_vault_name" {
  type        = string
  description = "Specifies the Key Vault name where SSL Certificate exists"
}

variable "key_vault_secret_for_ssl" {
  type        = string
  description = "Specifies the Key Vault Secret name for SSL Certificate"
}
