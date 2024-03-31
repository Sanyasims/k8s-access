resource "kubernetes_cluster_role_binding" "cluster_admins" {
  count = length(var.cluster_admins) > 0 ? 1 : 0
  metadata {
    name = "cluster-admins"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  dynamic "subject" {
    for_each = toset(var.cluster_admins)
    content {
      kind      = "User"
      name      = subject.value
      api_group = "rbac.authorization.k8s.io"
    }
  }
}

resource "kubernetes_cluster_role" "developer" {
  metadata {
    name = "developer"
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces", "nodes"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "cluster_developers" {
  count = length(var.cluster_developers) > 0 ? 1 : 0
  metadata {
    name = "cluster-developers"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "developer"
  }
  dynamic "subject" {
    for_each = toset(var.cluster_developers)
    content {
      kind      = "User"
      name      = subject.value
      api_group = "rbac.authorization.k8s.io"
    }
  }
}