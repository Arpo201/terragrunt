variable "provider_info" {
  type = object({
    cloud_provider = optional(string, "vmware")
    user           = string
    password       = string
    server         = string
  })
  description = "Connect vSphere"
  sensitive   = true
}

# ---------------- VM master node -----------------
variable "master_node" {
  type = object({
    name       = optional(string, "master_node")
    num        = number
    cpus       = number
    memory     = number
    disk_size  = number
    ip         = list(string)
    subnetmask = string
    gateway_ip = string
    dns        = string
    ssh_keys   = list(string)
  })
  description = "cpu (cores num) | memory (MB) | disk (GB) | subnet (/24)"
}
# --------------------------------------------------


# ---------------- VM worker node -----------------
variable "worker_node" {
  type = object({
    name       = optional(string, "worker_node")
    num        = number
    cpus       = number
    memory     = number
    disk_size  = number
    ip         = list(string)
    subnetmask = string
    gateway_ip = string
    dns        = string
    ssh_keys   = list(string)
  })
  description = "cpu (cores num) | memory (MB) | disk (GB) | subnet (/24)"
}
# --------------------------------------------------

# ---------------- VM Master loadbalancer -----------------
variable "master_lb" {
  type = object({
    name       = optional(string, "master_lb")
    num        = number
    cpus       = number
    memory     = number
    disk_size  = number
    ip         = list(string)
    subnetmask = string
    gateway_ip = string
    dns        = string
    ssh_keys   = list(string)
  })
  description = "cpu (cores num) | memory (MB) | disk (GB) | subnet (/24)"
}

# --------------------------------------------------

# ---------------- VM Worker loadbalancer -----------------
variable "worker_lb" {
  type = object({
    name       = optional(string, "worker_lb")
    num        = number
    cpus       = number
    memory     = number
    disk_size  = number
    ip         = list(string)
    subnetmask = string
    gateway_ip = string
    dns        = string
    ssh_keys   = list(string)
  })
  description = "cpu (cores num) | memory (MB) | disk (GB) | subnet (/24)"
}

# --------------------------------------------------

variable "kubespray_inventory_name" {
  type        = string
  default     = "project_a_test_cluster"
  description = "Kubespray inventory name"
}

variable "cluster_name" {
  type        = string
  description = "kubernetes cluster name"
}

variable "kube_version" {
  type        = string
  description = "kubernetes version"
  default     = "v1.24.6"
}
