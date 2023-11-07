resource "kubernetes_service" "nginx_ingress" {
  metadata {
    name      = local.app_name
    namespace = data.kubernetes_namespace.ns.metadata.0.name

    labels = local.labels

    annotations = var.lb_annotations
  }

  spec {
    type = "LoadBalancer"
    selector = {
      "app.kubernetes.io/name"    = local.app_name
      "app.kubernetes.io/part-of" = data.kubernetes_namespace.ns.metadata.0.name
    }

    external_traffic_policy = "Cluster"

    dynamic "port" {
      for_each = var.lb_ports

      content {
        name        = port.value.name
        port        = port.value.port
        target_port = port.value.target_port
      }
    }
    load_balancer_source_ranges = var.load_balancer_source_ranges
  }
}