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

###Helm Release Cert Manager Variables###
variable "cert_manager_helm_name" {
    type = string
}

variable "cert_manager_helm_repository" {
    type = string
}

variable "cert_manager_helm_chart" {
    type = string
}

variable "cert_manager_helm_namespace" {
    type = string
}

variable "cert_manager_helm_create_namespace" {
    type = string
}

variable "cert_manager_install_CRD" {
    type = string
}

variable "cert_manager_replica_count" {
    type = string
}

variable "cert_manager_node_selector" {
    type = string
}

###Cluster Issuer Variables###
variable "letsencrypt_email" {
    type = string
    sensitive   = true
}

variable "letsencrypt_cloudflare_api_token" {
  type        = string
  sensitive   = true
}