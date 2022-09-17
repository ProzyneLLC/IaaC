###Enviroment Varibales###
variable "current_branch_name" {
    type = string
}

###Non secrete Variables###
variable "resource_group_name" {
    type = string
}

variable "resource_location" {
    type = string
}

###Mysql Variables###
variable "mysql_backup_retention_days" {
    type = number
}

variable "mysql_sku" {
    type = string
}