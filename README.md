# terraform-ingress-controller

## Example Usage

module "ingress_controller" { 
  source                  = "git@github.com:blockopsnetwork/terraform-ingress-controller?ref=ingress-controller-setup"
  namespace               = "sre"
  replicas = {
    min = 1
    max = 3
  }
}