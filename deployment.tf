resource "kubernetes_deployment" "nginx_ingress" {
  wait_for_rollout = false

  metadata {
    name      = local.app_name
    namespace = data.kubernetes_namespace.ns.metadata.0.name
    labels    = local.labels
  }

  spec {
    replicas = var.replicas.min

    selector {
      match_labels = local.selectorLabels
    }

    template {
      metadata {
        labels = local.selectorLabels
        annotations = {
          "prometheus.io/port"   = var.prometheus_port
          "prometheus.io/scrape" = var.prometheus_scrape
        }
      }

      spec {
        service_account_name             = kubernetes_service_account.nginx_ingress.metadata.0.name
        termination_grace_period_seconds = 300
        node_selector                    = var.deployment_node_selector
        priority_class_name              = var.priority_class_name

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              topology_key = "kubernetes.io/hostname"
              label_selector {
                match_expressions {
                  key      = "app.kubernetes.io/app"
                  operator = "In"
                  values   = [local.app_name]
                }
              }
            }
          }
          node_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 1
              preference {
                match_expressions {
                  key      = "restart"
                  operator = "In"
                  values   = ["unlikely"]
                }
              }
            }
          }
        }

        toleration {
          effect   = "NoSchedule"
          key      = "onlyfor"
          operator = "Equal"
          value    = "highcpu"
        }
        toleration {
          effect   = "NoSchedule"
          key      = "dbonly"
          operator = "Equal"
          value    = "yes"
        }

        container {
          image             = "${var.nginx_image}"
          name              = "nginx-ingress-controller"
          image_pull_policy = "IfNotPresent"
          lifecycle {
            pre_stop {
              exec {
                command = ["/wait-shutdown"]
              }
            }
          }
          args = [
            "/nginx-ingress-controller",
            "--configmap=$(POD_NAMESPACE)/${kubernetes_config_map.nginx_ingress.metadata.0.name}",
            "--publish-service=$(POD_NAMESPACE)/${kubernetes_service.nginx_ingress.metadata.0.name}",
            "--election-id=${local.app_name}-leader",
            "--ingress-class=nginx"
          ]
          security_context {
            capabilities {
              drop = ["ALL"]
              add  = ["NET_BIND_SERVICE"]
            }
            run_as_user                = 101
            allow_privilege_escalation = true
          }
          env {
            name = "POD_NAME"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }
          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          env {
            name  = "LD_PRELOAD"
            value = "/usr/local/lib/libmimalloc.so"
          }
          port {
            name           = "http"
            container_port = 80
            protocol       = "TCP"
          }
          port {
            name           = "https"
            container_port = 443
            protocol       = "TCP"
          }
          resources {
            limits = {
              cpu    = var.nginx_resources.limits.cpu
              memory = var.nginx_resources.limits.memory
            }
            requests = {
              cpu    = var.nginx_resources.requests.cpu
              memory = var.nginx_resources.requests.memory
            }
          }

          liveness_probe {
            http_get {
              path = "/healthz"
              port = 10254
            }
            initial_delay_seconds = 10
            period_seconds        = 10
            success_threshold     = 1
            timeout_seconds       = 1
            failure_threshold     = 5
          }
          readiness_probe {
            http_get {
              path = "/healthz"
              port = 10254
            }
            initial_delay_seconds = 10
            period_seconds        = 10
            success_threshold     = 1
            timeout_seconds       = 1
            failure_threshold     = 5
          }
        }
      
      }
    }
  }

  depends_on = [
    kubernetes_role_binding.nginx_ingress
  ]
}
