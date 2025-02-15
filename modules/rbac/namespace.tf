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

  for_each = { 
    for namespace in var.namespaces : namespace.namespace => namespace
    if length(namespace.viewers) > 0  
  }
  metadata {
    name      = format("%s-%s",each.key,"viewers")
    namespace = each.key
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"
  }

  dynamic "subject" {
    for_each = toset(each.value.viewers)
    content {
      
      kind      = "User"
      name      = subject.value
      api_group = "rbac.authorization.k8s.io"
    }
  }
}

resource "kubernetes_role_binding" "editors" {

  for_each = { 
    for namespace in var.namespaces : namespace.namespace => namespace 
    if length(namespace.editors) > 0
  }
  metadata {
    name      = format("%s-%s",each.key,"editors")
    namespace = each.key
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "edit"
  }

  dynamic "subject" {
    for_each = toset(each.value.editors)
    content {
      
      kind      = "User"
      name      = subject.value
      api_group = "rbac.authorization.k8s.io"
    }
  }
}



resource "kubernetes_secret" "docker_registry_secret" {
  for_each = { for namespace in var.namespaces : namespace.namespace => namespace }
  metadata {
    name = "docker-registry-secret"
    namespace = each.key
  }

  data = {
    ".dockerconfigjson" = var.DOCKER_CONFIG
  }

  type = "kubernetes.io/dockerconfigjson"
}