
# -
# - Azure virtual machine for windows
# -
resource "azurerm_virtual_machine" "az_virtual_machine_windows" {
  name                             = var.windows_vm_name
  resource_group_name              = var.resource_group_name
  location                         = var.location
  availability_set_id              = var.availability_set_id
  vm_size                          = var.windows_vm_size
  network_interface_ids            = var.network_interface_ids
  delete_os_disk_on_termination    = var.delete_os_disk_on_termination
  delete_data_disks_on_termination = var.delete_data_disks_on_termination
  primary_network_interface_id     = var.primary_network_interface_id
  proximity_placement_group_id     = var.proximity_placement_group_id
  zones                            = var.zones
  license_type                     = var.license_type

  # boot diagnostics config block
  boot_diagnostics {
    enabled     = lookup(var.boot_diagnostics, "enabled", false)
    storage_uri = lookup(var.boot_diagnostics, "storage_uri", "")
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
  os_profile {
    computer_name  = var.windows_vm_name
    admin_username = lookup(var.os_profile, "admin_username", null)
    admin_password = lookup(var.os_profile, "admin_password", null)
    custom_data    = lookup(var.os_profile, "custom_data", null)
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

  # os profile windows config block
  os_profile_windows_config {
    provision_vm_agent        = lookup(var.os_profile_windows_config, "provision_vm_agent", true)
    enable_automatic_upgrades = lookup(var.os_profile_windows_config, "enable_automatic_upgrades", false)
    timezone                  = lookup(var.os_profile_windows_config, "timezone", null)
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

  # os disk storage config block
  storage_os_disk {
    name                      = "osdisk-${var.windows_vm_name}"
    caching                   = lookup(var.storage_os_disk, "caching", null)
    create_option             = lookup(var.storage_os_disk, "create_option", null)
    managed_disk_type         = lookup(var.storage_os_disk, "managed_disk_type", null)
    disk_size_gb              = lookup(var.storage_os_disk, "disk_size_gb", null)
    image_uri                 = lookup(var.storage_os_disk, "image_uri", null)
    os_type                   = lookup(var.storage_os_disk, "os_type", null)
    write_accelerator_enabled = lookup(var.storage_os_disk, "write_accelerator_enabled", null)
    managed_disk_id           = lookup(var.storage_os_disk, "managed_disk_id", null)
    vhd_uri                   = lookup(var.storage_os_disk, "vhd_uri", null)
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

