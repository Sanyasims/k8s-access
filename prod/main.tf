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
  DOCKER_CONFIG = var.DOCKER_CONFIG
}

variable "DOCKER_CONFIG" {
  type = string
}

variable "cluster_admins" {
  type = list(string)
  default = []
}

variable "cluster_developers" {
  type = list(string)
  default = []
}

variable "namespaces" {
  type = list(object({
    namespace = string,
    viewers = list(string),
    editors = list(string)
  }))
  default = []
}