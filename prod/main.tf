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
    viewers = list(string),
    editors = list(string)
  }))
  default = [ 
  {
    namespace = "terraform-example-namespace"
    viewers = [
      "artemenko.n.argonlabs@gmail.com"
    ]
    editors = [

    ]
  }
  ]

}

     

resource "kubernetes_namespace" "namespace" {
  for_each = { for namespace in var.namespaces : namespace.namespace => namespace }
  metadata {
    name = each.key
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "kubernetes_role_binding" "viewers" {

  for_each = { for namespace in var.namespaces : namespace.namespace => namespace }
  metadata {
    name      = format("%s-/%s",each.key,"viewers")
    namespace = each.key
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "viewer"
  }

  dynamic "subject" {
    for_each = toset(each.value.viewers)
    content {
      
      kind      = "User"
      name      = each.value
      api_group = "rbac.authorization.k8s.io"
    }
  }
}