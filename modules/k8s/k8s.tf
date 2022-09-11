resource "kubernetes_namespace" "nginx_1_namespace" {
  metadata {
    labels = {
      app = "nginx1"
    }
    name = "nginx1-namespace"
  }
}

resource "kubernetes_deployment" "nginx_1" {
  metadata {
    name = "nginx1"
    namespace = "nginx1-namespace"
    labels = {
      app = "nginx1"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nginx1"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx1"
        }
      }

      spec {
        container {
          image = "nginx:1.7.8"
          name  = "nginx1"

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
        }
      }
    }
  }
}

resource "kubernetes_service" "service_nginx_1" {
  depends_on = [kubernetes_deployment.nginx_1]

  metadata {
    labels = {
      app = "nginx1"
    }
    name = "service-nginx1"
    namespace = "nginx1-namespace"
  }

  spec {
    selector = {
      app = "nginx1"
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
}