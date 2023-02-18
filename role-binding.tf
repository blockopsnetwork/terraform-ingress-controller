resource "kubernetes_role_binding" "nginx_ingress" {
  metadata {
    name      = local.app_name
    namespace = data.kubernetes_namespace.ns.metadata.0.name
    labels    = local.labels
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.nginx_ingress.metadata.0.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.nginx_ingress.metadata.0.name
    namespace = kubernetes_service_account.nginx_ingress.metadata.0.namespace
  }
}