###Secret Varibales###
variable "current_branch_name" {
    type = string
}

# variable "sp_client_id" {
#     type = string
# }

# variable "sp_client_secret" {
#     type = string
# }

###Non secrete Variables###
variable "resource_location" {
    default = "West Europe"
}