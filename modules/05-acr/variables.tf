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

###ACR Variables###
variable "acr_sku" {
    type = string
}