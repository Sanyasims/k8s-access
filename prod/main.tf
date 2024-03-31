provider "kubernetes" {
}

terraform {
  backend "gcs" {
    bucket = "terraform-state-argond"
    prefix = "cluster/prod"
  }
}

# Полный доступ к кластеру
variable "cluster_admins" {
  type = list(string)
  default = [
    "artesan538@gmail.com",
    "gr.azatyan@gmail.com",
    "althazari@gmail.com"
  ]
}

# Просмотр существующих нод и неймспейсов
variable "cluster_developers" {
  type = list(string)
  default = [
    "artemenko.n.argonlabs@gmail.com"
  ]
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
      ]
      editors = [
      ]
    }
  ]
}
