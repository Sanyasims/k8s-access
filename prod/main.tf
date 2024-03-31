provider "kubernetes" {
}

terraform {
  backend "gcs" {
    bucket = "terraform-state-argond"
    prefix = "cluster/prod"
  }
}


variable "cluster_admins" {
  type = list(string)
  default = [
    "artemenko.n.argonlabs@gmail.com"
  ]
}

variable "cluster_developers" {
  type = list(string)
  default = [

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
      "testuser1@gmail.com",
      "testuser2@gmail.com"
    ]
    editors = [
      "artemenko.n.argonlabs@gmail.com"
    ]
  }
  ]
}
