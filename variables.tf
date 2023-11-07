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