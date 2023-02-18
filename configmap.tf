locals {
  default_response_headers = {
    # set by nginx: x-request-id header or auto generated
    "x-request-id" = "$req_id"
  }

  default_request_headers = {
    "true-client-ip" = "$http_true_client_ip"
    "x-request-id" = "$req_id"
  }
}

resource "kubernetes_config_map" "request_headers" {
  metadata {
    name      = "${local.app_name}-nginx-request-headers"
    namespace = data.kubernetes_namespace.ns.metadata.0.name
    labels    = local.labels
  }

  data = merge(local.default_request_headers, try(var.nginx_extra_request_headers, {}))
}

resource "kubernetes_config_map" "response_headers" {
  metadata {
    name      = "${local.app_name}-nginx-response-headers"
    namespace = data.kubernetes_namespace.ns.metadata.0.name
    labels    = local.labels
  }

  data = merge(local.default_response_headers, try(var.nginx_extra_response_headers, {}))
}

resource "kubernetes_config_map" "nginx_ingress" {
  metadata {
    name      = "${local.app_name}-nginx"
    namespace = data.kubernetes_namespace.ns.metadata.0.name
    labels    = local.labels
  }

  data = merge(
    var.nginx_configmap_entries,
    {
      # sent upstream
      proxy-set-headers = "${kubernetes_config_map.request_headers.metadata.0.namespace}/${kubernetes_config_map.request_headers.metadata.0.name}"
      # added to response
      add-headers                 = "${kubernetes_config_map.response_headers.metadata.0.namespace}/${kubernetes_config_map.response_headers.metadata.0.name}"
      large-client-header-buffers = "8 16k"
    }
  )
}