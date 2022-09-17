###Helm Variables###
variable "nginx_helm_name" {
    type = string
}

variable "nginx_helm_repository" {
    type = string
}

variable "nginx_helm_chart" {
    type = string
}

# variable "nginx_helm_version" {
#     type = string
# }

variable "nginx_helm_namespace" {
    type = string
}

variable "nginx_helm_create_namespace" {
    type = string
}


###Set Variables###
variable "nginx_ingress_controller_replica_count" {
    type = string
}

variable "nginx_ingress_controller_node_selector" {
    type = string
}

variable "nginx_ingress_defaultBackend_node_selector" {
    type = string
}

variable "nginx_ingress_service_type" {
    type = string
}

variable "nginx_ingress_service_external_traffic_policy" {
    type = string
}