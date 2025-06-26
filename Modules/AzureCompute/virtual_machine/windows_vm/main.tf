
# -
# - Azure virtual machine for windows
# -
resource "azurerm_windows_virtual_machine" "az_virtual_machine_windows" {
  name                         = var.windows_vm_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  availability_set_id          = var.availability_set_id
  size                         = var.windows_vm_size
  network_interface_ids        = var.network_interface_ids
  proximity_placement_group_id = var.proximity_placement_group_id
  license_type                 = var.license_type
  admin_username               = var.admin_username
  admin_password               = var.admin_password

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

  # os profile secrets config block
  dynamic "os_profile_secrets" {
    for_each = var.os_profile_secrets
    content {
      source_vault_id = lookup(os_profile_secrets.value, "source_vault_id", null)

      vault_certificates {
        certificate_url   = lookup(os_profile_secrets.value, "certificate_url", null)
        certificate_store = lookup(os_profile_secrets.value, "certificate_store", null)
      }
    }
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
  dynamic "storage_image_reference" {
    for_each = lookup(var.storage_image_reference, "id", null) == null ? [1] : []

    content {
      publisher = var.storage_image_reference.publisher
      offer     = var.storage_image_reference.offer
      sku       = var.storage_image_reference.sku
      version   = var.storage_image_reference.version
    }
  }

  # Reference an image gallery ID
  dynamic "storage_image_reference" {
    for_each = lookup(var.storage_image_reference, "id", null) == null ? [] : [1]

    content {
      id = var.storage_image_reference.id
    }
  }

  # data disk storage config block
  dynamic "storage_data_disk" {
    for_each = var.storage_data_disk
    content {
      name                      = "${var.windows_vm_name}-${storage_data_disk.key}"
      caching                   = lookup(storage_data_disk.value, "caching", null)
      create_option             = lookup(storage_data_disk.value, "create_option", "Empty")
      disk_size_gb              = lookup(storage_data_disk.value, "disk_size_gb", null)
      lun                       = storage_data_disk.key
      write_accelerator_enabled = lookup(storage_data_disk.value, "write_accelerator_enabled", null)
      managed_disk_type         = lookup(storage_data_disk.value, "managed_disk_type", null)
      managed_disk_id           = lookup(storage_data_disk.value, "managed_disk_id", null)
      vhd_uri                   = lookup(storage_data_disk.value, "vhd_uri", null)
    }
  }

  tags = var.windows_vm_tags
}

