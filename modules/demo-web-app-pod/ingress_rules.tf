resource "kubernetes_ingress_v1" "nginx-ingress" {
  wait_for_load_balancer = true
  metadata {
    name = "nginx-ingress-1"
    namespace = "nginx-namespace"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
      "cert-manager.io/cluster-issuer" = "letsencrypt-test"
      "certmanager.k8s.io/acme-challenge-type" = "dns01"
      "certmanager.k8s.io/acme-dns01-provider"  ="cf-dns"
      "ingress.kubernetes.io/ssl-redirect"  = "true"
      "kubernetes.io/tls-acme" = "true"
    }
  }

  spec {
    ingress_class_name = "nginx"
    rule {
      host = "test.pierreridderstap.nl"
      http {
        path {
          path = "/hello"
          path_type = "Exact"
          backend {
            service {
              name = "service-nginx"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
    tls {
      hosts = ["test.pierreridderstap.nl"]
      secret_name = "tls-secret-prod"
    }
  }
}