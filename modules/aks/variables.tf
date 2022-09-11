###Enviroment Varibales###
variable "current_branch_name" {
    type = string
}

variable "sp_client_id" {
    default = "4ee2b0fe-3be0-467e-8311-cceaa6b3c145"
}

variable "sp_client_secret" {
    default = "Hu08Q~aiqTbWDllYFWQPxc5IwgnahuEjt~EkSbPF"
}

###Non secrete Variables###
variable "resource_group_name" {
    type = string
}

variable "resource_location" {
    type = string
}

###AKS Variables###
variable "kubernetes_version" {
    type = string
}

variable "aks_node_size" {
    type = string
}

variable "aks_node_type" {
    type = string
}

variable "aks_node_count" {
    type = number
}

variable "aks_node_disk_size" {
    type = number
}

variable "aks_vnet_subnet_id" {
}