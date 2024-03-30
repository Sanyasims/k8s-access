provider "kubernetes" {
}

terraform {
  backend "gcs" {
    bucket = "terraform-state-argond"
    prefix = "cluster/prod"
  }
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
    users = []
  },
  {
    namespace = "terraform-example-namespace111"
    users = []
  }
  ]

}

      # {
      #   name = "artemenko.n.argonlabs@gmail.com"
      #   role = "viewer"
      # }

resource "kubernetes_namespace" "namespace" {
  for_each = { for namespace in var.namespaces : namespace.namespace => namespace }
  metadata {
    name = each.key
  }
  lifecycle {
    prevent_destroy = true
  }
}