resource "kubernetes_namespace" "mcr1_namespace" {
  metadata {
    labels = {
      app = "mcr1"
    }
    name = "mcr1-namespace"
  }
}

resource "kubernetes_deployment_v1" "mcr1" {
  metadata {
    name = "mcr1"
    namespace = "mcr1-namespace"
    labels = {
      app = "mcr1"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mcr1"
      }
    }

    template {
      metadata {
        labels = {
          app = "mcr1"
        }
      }

      spec {
        container {
          image = "mcr.microsoft.com/azuredocs/aks-helloworld:v1"
          name  = "mcr1"

          env {
            name = "TITLE"
            value = "Welcome to Azure Kubernetes Service (AKS)"
          }

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

resource "kubernetes_service_v1" "service_mcr1" {
  depends_on = [kubernetes_deployment_v1.mcr1]

  metadata {
    name = "service-mcr1"
    namespace = "mcr1-namespace"
    labels = {
      app = "mcr1"
    }
  }

  spec {
    selector = {
      app = "mcr1"
    }
    port {
      port        = 80
      protocol = "TCP"
      target_port = 80
    }

    type = "ClusterIP"
  }
}