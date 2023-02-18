resource "kubernetes_service_account" "nginx_ingress" {
  metadata {
    name      = local.app_name
    namespace = data.kubernetes_namespace.ns.metadata.0.name
    labels    = local.labels
  }
}
