provider "kubernetes" {
}

variable "cluster_admins" {
  type = list(object({
    name = string
  }))
  default = [ ]
}
variable "namespaces" {
  type = list(object({
    namespace = string,
    users = list(object({
      name = string,
      role = string
    }))
  }))
  default = [ 
  {
    namespace = "terraform-example-namespace"
    users = [
      {
        name = "artemenko.n.argonlabs@gmail.com"
        role = "viewer"
      }
    ]
  }
  ]

}

resource "kubernetes_namespace" "namespace" {
  metadata {
    name = "terraform-example-namespace"
  }
  lifecycle {
    prevent_destroy = true
  }
}