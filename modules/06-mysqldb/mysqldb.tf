resource "azurerm_mysql_flexible_server" "mysqldb-fs" {
  name                   = "${var.current_branch_name}-mysqldb-fs"
  location              = var.resource_location
  resource_group_name   = var.resource_group_name
  
  administrator_login    = "${var.current_branch_name}_admin"
  administrator_password = "${var.current_branch_name}_not_so_secure_password_123"

  backup_retention_days  = var.mysql_backup_retention_days
  sku_name               = var.mysql_sku
}