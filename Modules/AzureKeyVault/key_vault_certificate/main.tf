# -
# - Setup key vault certificate
# -
resource "azurerm_key_vault_certificate" "az_key_vault_certificate" {
  name         = var.key_vault_cert_name
  key_vault_id = var.key_vault_id
  tags         = var.key_vault_cert_tags

  certificate {
    contents = var.certificate_contents
    password = var.certificate_password
  }

  certificate_policy {
    issuer_parameters {
      name = var.cert_policy_values.certificate_policy.name
    }
    key_properties {
      exportable = var.cert_policy_values.certificate_policy.exportable
      key_size   = var.cert_policy_values.certificate_policy.key_size
      key_type   = try(var.cert_policy_values.certificate_policy.key_type, "RSA")
      reuse_key  = var.cert_policy_values.certificate_policy.reuse_key
    }
    # lifetime_action {
    #   action {
    #     action_type = var.cert_policy_values.certificate_policy.renewal_action
    #   }
    #   trigger {
    #     days_before_expiry  = try(var.cert_policy_values.certificate_policy.days_before_expiry, null)
    #     lifetime_percentage = try(var.cert_policy_values.certificate_policy.lifetime_percentage, null)
    #   }
    # }
    secret_properties {
      content_type = var.cert_policy_values.certificate_policy.content_type
    }

    dynamic "x509_certificate_properties" {
      for_each = try(var.cert_policy_values.certificate_policy.x509_certificate_properties, null) == null ? [] : [1]

      content {
        extended_key_usage = try(var.cert_policy_values.certificate_policy.x509_certificate_properties.extended_key_usage, null)
        key_usage          = var.cert_policy_values.certificate_policy.x509_certificate_properties.key_usage
        subject            = var.cert_policy_values.certificate_policy.x509_certificate_properties.subject
        validity_in_months = var.cert_policy_values.certificate_policy.x509_certificate_properties.validity_in_months

        dynamic "subject_alternative_names" {
          for_each = try(var.cert_policy_values.certificate_policy.x509_certificate_properties.subject_alternative_names, null) == null ? [] : [1]

          content {
            dns_names = try(var.cert_policy_values.certificate_policy.x509_certificate_properties.subject_alternative_names.dns_names, null)
            emails    = try(var.cert_policy_values.certificate_policy.x509_certificate_properties.subject_alternative_names.emails, null)
            upns      = try(var.cert_policy_values.certificate_policy.x509_certificate_properties.subject_alternative_names.upns, null)
          }
        }
      }
    }
  }
}