data "azurerm_public_ip" "cluster-pub-ip" {
  name                = "${var.current_branch_name}-${var.cluster_name}-pub-ip"
  resource_group_name = var.resource_group_name

depends_on = [ azurerm_public_ip.cluster-pub-ip ] 
}

resource "helm_release" "nginx_ingress" {
  depends_on = [ azurerm_public_ip.cluster-pub-ip ]
  name             = "${var.nginx_helm_name}"
  repository       = "${var.nginx_helm_repository}"
  chart            = "${var.nginx_helm_chart}"
  namespace        = "${var.nginx_helm_namespace}"
  create_namespace = "${var.nginx_helm_create_namespace}"

  set {
    name  = "controller.replicaCount"
    value = "${var.nginx_ingress_controller_replica_count}"
  }
  set {
    name  = "controller.nodeSelector.beta\\.kubernetes\\.io/os"
    value = "${var.nginx_ingress_controller_node_selector}"
  }
  set {
    name  = "defaultBackend.nodeSelector.beta\\.kubernetes\\.io/os"
    value = "${var.nginx_ingress_defaultBackend_node_selector}"
  }
  set {
    name  = "controller.service.type"
    value = "${var.nginx_ingress_service_type}"
  }
  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "${var.nginx_ingress_service_external_traffic_policy}"
  }
  set {
    name  = "controller.service.loadBalancerIP"
    value = "${data.azurerm_public_ip.cluster-pub-ip.ip_address}"
  }
  set {
    name  = "controller.service.annotations.\"service\\.beta\\.kubernetes\\.io/azure-load-balancer-resource-group\""
    value = "${var.nginx_ingress_controller_service_annotations}"
  }
}