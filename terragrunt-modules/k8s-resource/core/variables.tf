variable "namespace" {
  type = object({
    core         = string
    datastore    = string
    tools = string
  })
  default = {
    core         = "core"
    datastore    = "datastore"
    tools = "tools"
  }
  description = "namespaces"
}

variable "k8s_cluster_name" {
  type        = string
  description = "k8s cluster name"
}

variable "k8s_cluster_endpoint" {
  type        = string
  description = "k8s cluster endpoint"
}

variable "k8s_cluster_ca_certificate" {
  type        = string
  description = "k8s cluster ca certificate"
  sensitive = true
}

variable "test_core" {
  type        = string
  description = "test_core"
}
