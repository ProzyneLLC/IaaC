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

###AKS configuration Variables###
variable "kubernetes_version" {
    type = string
}

variable "azure_policy_enabled" {
    type = bool
}

variable "oidc_issuer_enabled" {
    type = bool
}

###Default Node Pool Variables###
variable "aks_d_node_name" {
    type = string
}

variable "aks_d_node_size" {
    type = string
}

variable "aks_d_node_type" {
    type = string
}

variable "aks_d_node_count" {
    type = number
}

variable "aks_d_node_disk_size" {
    type = number
}

###User Node Pool Variables###
variable "aks_u_node_name" {
    type = string
}

variable "aks_u_node_size" {
    type = string
}

variable "aks_u_node_count" {
    type = number
}

variable "aks_u_node_disk_size" {
    type = number
}

###AKS network profile Variables###
variable "aks_network_plugin" {
    type = string
}

variable "aks_load_balancer_sku" {
    type = string
}

# variable "aks_vnet_subnet_id" {
# }