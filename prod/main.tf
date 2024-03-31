provider "kubernetes" {
}

terraform {
  backend "gcs" {
    bucket = "terraform-state-argond"
    prefix = "cluster/prod"
  }
}

module "rbac" {
  source = "../modules/rbac"

  cluster_admins = var.cluster_admins
  cluster_developers = var.cluster_developers

  namespaces = var.namespaces
}