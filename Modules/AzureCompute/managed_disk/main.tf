
resource "azurerm_managed_disk" "az_managed_disk" {
  name                 = var.disk_name
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = var.storage_account_type
  create_option        = var.create_option
  disk_size_gb         = var.disk_size_gb

  tags = var.managed_disk_tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "az_managed_disk_attachment" {
  managed_disk_id    = azurerm_managed_disk.example.id
  virtual_machine_id = var.vm_id
  lun                = var.lun
  caching            = "ReadWrite"
}