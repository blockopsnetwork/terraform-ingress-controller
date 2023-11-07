variable "namespace" {
  description = "Deployment namespace"
  type        = string
}

variable "replicas" {
  description = "Number of deployment replicas"
  type = object({
    max = number
    min = number
  })
  default = {
    max = 12
    min = 3
  }
}

variable "prometheus_scrape" {
  description = "Enable prometheus scraping"
  type        = bool
  default     = true
}

variable "prometheus_port" {
  description = "Set prometheus port"
  type        = number
  default     = 10254
}


variable "nginx_configmap_entries" {
  description = "Key-value pairs to be added to nginx configmap"
  type        = map(string)
  default     = {}
}

variable "nginx_extra_request_headers" {
  description = "Additional nginx request headers"
  type        = map(string)
  default     = {}
}

variable "nginx_extra_response_headers" {
  description = "Additional nginx response headers"
  type        = map(string)
  default     = {}
}

variable "nginx_image" {
  description = "Nginx container image"
  type = string
  default = "registry.k8s.io/ingress-nginx/controller:v1.2.1@sha256:5516d103a9c2ecc4f026efbd4b40662ce22dc1f824fb129ed121460aaa5c47f8"
}

variable "nginx_resources" {
  description = "Nginx container resource configuration"
  type = object({
    limits = object({
      cpu    = string
      memory = string
    })
    requests = object({
      cpu    = string
      memory = string
    })
  })
  default = {
    limits = {
      cpu    = "2"
      memory = "1G"
    }
    requests = {
      cpu    = "1"
      memory = "512M"
    }
  }
}


variable "nginx_ingress_controller_image_tag" {
  description = "The image tag to use for the NGINX ingress controller. See https://github.com/kubernetes/ingress-nginx/releases for available versions"
  type        = string
  default     = "v0.44.0@sha256:3dd0fac48073beaca2d67a78c746c7593f9c575168a17139a9955a82c63c4b9a"
}

variable "deployment_node_selector" {
  description = "Map of label names and values to assign the podspec's nodeSelector property"
  type        = map(string)
  default = null
}

variable "priority_class_name" {
  description = "The priority class to attach to the deployment"
  type        = string
  default     = null
}

variable "lb_annotations" {
  description = "Annotations to add to the loadbalancer"
  type        = map(string)
  default = {
    "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
    "service.beta.kubernetes.io/aws-load-balancer-scheme" = "internet-facing"
    "service.beta.kubernetes.io/aws-load-balancer-name" = "blockops-testnet-lb"
    "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type" = "ip"
    "service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled" = "true"
    "service.beta.kubernetes.io/aws-load-balancer-name" = "blockops-testnet-lb"
    "service.beta.kubernetes.io/aws-load-balancer-subnets" = "subnet-00b8b96e244c4ca11, subnet-0b45c2527c341933b, subnet-0efc0704ddd82d424"
    "service.beta.kubernetes.io/aws-load-balancer-ssl-ports" = "443"
    "service.beta.kubernetes.io/load-balancer-source-ranges" = "0.0.0.0/0"

  }
}

variable "load_balancer_source_ranges" {
  description = "The ip whitelist that is allowed to access the load balancer"
  default     = ["0.0.0.0/0"]
  type        = list(string)
}

variable "lb_ports" {
  description = "Load balancer port configuration"
  type = list(object({
    name        = string
    port        = number
    target_port = string
  }))
  default = [{
    name        = "http"
    port        = 80
    target_port = "http"
    }, {
    name        = "https"
    port        = 443
    target_port = "https"
  }]
}