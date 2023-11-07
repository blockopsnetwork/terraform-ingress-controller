
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.3.2"
    }
  }
}

data "kubernetes_namespace" "ns" {
  metadata {
    name = var.namespace
  }
}