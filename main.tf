locals {
  app_name = "nginx-ingress-controller"
  labels = {
    "app.kubernetes.io/app"        = local.app_name
    "app.kubernetes.io/owner"      = "sre"
    "app.kubernetes.io/managed-by" = "Terraform"
  }
  selectorLabels = {
    "app.kubernetes.io/app" = local.app_name
  }
}

