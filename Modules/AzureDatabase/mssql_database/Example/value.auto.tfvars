collation           = "SQL_Latin1_General_CP1_CI_AS"
license_type        = "LicenseIncluded"
max_size_gb         = 4
mssql_database_name = "test-db"
sku_name            = "BC_Gen5_2"

create_mode = "Default"

mssql_db_tags = {
  Name        = "terraform-demo-vent"
  Environment = "Dev"
}