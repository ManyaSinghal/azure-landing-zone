
# -
# - Azure virtual machine for windows
# -
resource "azurerm_windows_virtual_machine" "az_virtual_machine_windows" {
  name                  = var.windows_vm_name
  resource_group_name   = var.resource_group_name
  location              = var.location
  availability_set_id   = var.availability_set_id
  size                  = var.windows_vm_size
  network_interface_ids = var.network_interface_ids
  license_type          = var.license_type
  admin_username        = var.admin_username
  admin_password        = var.admin_password

  # boot diagnostics config block
  boot_diagnostics {
    storage_account_uri = lookup(var.boot_diagnostics, "storage_uri", "")
  }

  # additional capabilities config block
  additional_capabilities {
    ultra_ssd_enabled = var.ultra_ssd_enabled
  }

  #identity config block
  dynamic "identity" {
    for_each = length(var.identity_ids) == 0 && var.identity_type == "SystemAssigned" ? [var.identity_type] : []
    content {
      type = var.identity_type
    }
  }

  dynamic "identity" {
    for_each = length(var.identity_ids) > 0 || var.identity_type == "UserAssigned" ? [var.identity_type] : []
    content {
      type         = var.identity_type
      identity_ids = length(var.identity_ids) > 0 ? var.identity_ids : []
    }
  }

  # os profile config block
  os_disk {
    caching = lookup(var.os_disk, "caching", "ReadWrite")

    disk_size_gb         = lookup(var.os_disk, "disk_size_gb", null)
    storage_account_type = lookup(var.os_disk, "storage_account_type", "Standard_LRS")
  }

  # plan config block
  dynamic "plan" {
    for_each = var.plan

    content {
      name      = plan.value.name
      product   = plan.value.product
      publisher = plan.value.publisher
    }
  }

  # Reference from marketplace image
  source_image_reference {

    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }
  tags = var.windows_vm_tags
}

