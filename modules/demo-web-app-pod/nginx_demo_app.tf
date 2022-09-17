resource "kubernetes_namespace" "nginx_namespace" {
  metadata {
    labels = {
      app = "nginx"
    }
    name = "nginx-namespace"
  }
}

resource "kubernetes_deployment_v1" "nginx" {
  metadata {
    name = "nginx"
    namespace = "nginx-namespace"
    labels = {
      app = "nginx"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          image = "nginx:1.14.2"
          name = "nginx"

          port {
            container_port = 80
            protocol = "TCP"
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }

            initial_delay_seconds = 30
            period_seconds        = 60
            timeout_seconds = 30
            failure_threshold = 2
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "service_nginx" {
  depends_on = [kubernetes_deployment_v1.nginx]

  metadata {
    name = "service-nginx"
    namespace = "nginx-namespace"
    labels = {
      app = "nginx"
    }
  }

  spec {
    selector = {
      app = "nginx"
    }
    port {
      port        = 80
      protocol = "TCP"
      target_port = 80
    }

    type = "ClusterIP"
  }
}