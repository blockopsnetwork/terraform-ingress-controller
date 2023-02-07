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
  type = object({
    base    = string
    version = string
  })
  default = {
    base    = "k8s.gcr.io/ingress-nginx/controller"
    version = "v1.0.3"
  }
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
