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

resource "kubernetes_secret" "letsencrypt_cloudflare_api_token_secret" {
  depends_on = [
    helm_release.cert_manager
  ]
  metadata {
    name      = "prozynetoken"
    namespace = "${var.cert_manager_helm_namespace}"
  }

  data = {
    "api-token" = "${var.letsencrypt_cloudflare_api_token}"
  }
}

resource "kubernetes_manifest" "letsencrypt_issuer_staging" {
  depends_on = [
    helm_release.cert_manager,
    kubernetes_secret.letsencrypt_cloudflare_api_token_secret
  ]
  manifest = yamldecode(templatefile("../../modules/04-cert-manager/lets_encrypt_issuer.tpl.yaml",
    {
      "name"                      = "letsencrypt-${var.current_branch_name}"
      "email"                     = "${var.letsencrypt_email}"
      "server"                    = "https://acme-v02.api.letsencrypt.org/directory"
      "api_token_secret_name"     = kubernetes_secret.letsencrypt_cloudflare_api_token_secret.metadata.0.name
      "api_token_secret_data_key" = keys(kubernetes_secret.letsencrypt_cloudflare_api_token_secret.data).0
    }
  ))
}