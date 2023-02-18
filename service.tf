resource "kubernetes_service" "nginx_ingress" {
  metadata {
    name      = local.app_name
    namespace = data.kubernetes_namespace.ns.metadata.0.name
    labels    = local.labels
  }

  spec {
    selector = local.labels

    port {
      name        = "http"
      port        = 80
      target_port = "http"
    }

    port {
      name        = "https"
      port        = 443
      target_port = "https"
    }
  }
}
