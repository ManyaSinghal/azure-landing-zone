key_vault_certificate_name = "test-cert"

certificate_password = "test-password"
tags = {
  Name        = "terraform-demo-vent"
  Environment = "Dev"
}

cert_policy_values = {
  certificate_policy = {
    name           = "Self"
    exportable     = true
    key_size       = 2048
    key_type       = "RSA"
    reuse_key      = true
    content_type   = "application/x-pkcs12"
    renewal_action = "AutoRenew"
    x509_certificate_properties = {
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"]
      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]
      subject            = "CN=hello-world"
      validity_in_months = 12
      subject_alternative_names = {
        dns_names = ["internal.contoso.com", "domain.hello.world"]
        emails    = ["test@gmail.com"]
        upns      = ["wetwewetrew"]
      }
    }
  }
}