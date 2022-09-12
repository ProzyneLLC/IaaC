resource "kubernetes_ingress_v1" "ingress" {
  depends_on = [helm_release.nginx_ingress]
  wait_for_load_balancer = true
  metadata {
    name = "ingress"
    namespace = "mcr1-namespace"
    annotations = {
      "nginx.ingress.kubernetes.io/ingress.class"           = "nginx"
      # "nginx.ingress.kubernetes.io/ssl-redirect"           = "false"
      # "nginx.ingress.kubernetes.io/use-regex"      = "true"
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    ingress_class_name = "nginx"
    rule {
      http {
        path {
          path = "/hello"
          path_type = "Exact"
          backend {
            service {
              name = "service-mcr1"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}