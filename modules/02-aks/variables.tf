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

variable "aks_network_plugin" {
    type = string
}

variable "aks_load_balancer_sku" {
    type = string
}

# variable "aks_vnet_subnet_id" {
# }