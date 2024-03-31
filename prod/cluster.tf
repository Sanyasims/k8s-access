resource "kubernetes_cluster_role_binding" "cluster_admins" {
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