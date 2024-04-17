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

variable "DOCKER_CONFIG" {
  type = string
}
