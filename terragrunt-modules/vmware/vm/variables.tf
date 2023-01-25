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

# ---------------- Data source -----------------
variable "data_source" {
  type = object({
    datacenter_name      = string
    datastore_name       = string
    compute_cluster_name = string
    resource_pool_name   = string
    network_name         = string
  })
  description = "Data source"
  sensitive   = true
}

variable "vm_template_uuid" {
  type = object({
    node = string
    lb = string
    storage = string
  })
  description = "OVA UUID in vmware vsphere content libraries for create nodes in cluster"
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

# ---------------- VM storage -----------------
variable "storage_vm" {
  type = object({
    name       = optional(string, "storage_vm")
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