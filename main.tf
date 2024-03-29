provider "kubernetes" {
}



resource "kubernetes_namespace" "namespace" {
  metadata {
    name = "terraform-example-namespace"
  }
}