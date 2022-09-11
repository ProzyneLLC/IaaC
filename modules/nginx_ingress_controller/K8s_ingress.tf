resource "kubernetes_ingress_v1" "ingress" {
  wait_for_load_balancer = true
  metadata {
    name = "ingress"
  }

  spec {
    ingress_class_name = "nginx"
    rule {
      http {
        path {
          path = "/*"
          backend {
            service {
              name = "service-nginx1"
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