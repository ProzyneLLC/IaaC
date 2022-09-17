resource "helm_release" "cert_manager" {
  name             = "${var.cert_manager_helm_name}"
  repository       = "${var.cert_manager_helm_repository}"
  chart            = "${var.cert_manager_helm_chart}"
  namespace        = "${var.cert_manager_helm_namespace}"
  create_namespace = "${var.cert_manager_helm_create_namespace}"

  set {
    name  = "installCRDs"
    value = "${var.cert_manager_install_CRD}"
  }
  set {
    name  = "controller.replicaCount"
    value = "${var.cert_manager_replica_count}"
  }
  set {
    name  = "controller.nodeSelector.beta\\.kubernetes\\.io/os"
    value = "${var.cert_manager_node_selector}"
  }
}