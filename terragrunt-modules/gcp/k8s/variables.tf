variable "provider_info" {
  type = object({
    cloud_provider = optional(string, "gcp")
    credentials    = string
    project_id     = string
    region         = string
    zone           = string
  })
  description = "Information for use gcp"
}

variable "k8s_version" {
  type        = string
  description = "kubernetes version"
  default     = "latest"
}

variable "cluster_name" {
  type        = string
  description = "google cluster name"
}

variable "service_account" {
  type        = string
  description = "google service account email"
}

variable "vpc_name" {
  type        = string
  description = "vpc name"
}

variable "vpc_subnetwork_names" {
  type        = list(any)
  description = "subnet's primary IP address range is used for nodes"
}

variable "vpc_subnets_secondary_ranges" {
  type        = list(any)
  description = "first secondaty use for pods, second use for services"
}

variable "pool_name" {
  type        = string
  description = "Pool name"
  default     = "default-node-pool"
}

variable "pool_machine_type" {
  type        = string
  description = "machine type for node in pool"
  default     = "e2-standard-2"
}

variable "pool_min_node" {
  type        = number
  description = "minimum of node in pool"
  default     = 1
}

variable "pool_max_node" {
  type        = number
  description = "maximum of node in pool"
  default     = 3
}

variable "pool_init_node" {
  type        = number
  description = "number of initial node in pool"
  default     = 2
}

variable "pool_disk_type" {
  type        = string
  description = "disk type in pool"
  default     = "pd-standard"
}

variable "pool_disk_size_gb" {
  type        = number
  description = "disk size (gigabyte) in pool"
  default     = 100
}

variable "pool_image_type" {
  type        = string
  description = "node image type in pool"
  default     = "COS_CONTAINERD"
}

variable "http_load_balancing" {
  type        = bool
  description = "Enable httpload balancer addon"
  default     = false
}

variable "network_policy" {
  type        = bool
  description = "Enable network policy addon"
  default     = false
}

variable "horizontal_pod_autoscaling" {
  type        = bool
  description = "Enable horizontal pod autoscaling addon"
  default     = true
}

variable "filestore_csi_driver" {
  type        = bool
  description = "The status of the Filestore CSI driver addon, which allows the usage of filestore instance as volumes"
  default     = false
}

variable "enable_private_endpoint" {
  type        = bool
  description = "Enable private endpoint"
  default     = false
}

variable "enable_private_nodes" {
  type        = bool
  description = "Enable private nodes"
  default     = true
}

variable "remove_default_node_pool" {
  type        = bool
  description = "Remove default node pool or not"
  default     = true
}

variable "node_pools_local_ssd_count" {
  type        = number
  description = "Local ssd count"
  default     = 0
}

variable "node_pools_enable_gcfs" {
  type        = bool
  description = "Enable gcfs or not"
  default     = false
}

variable "node_pools_enable_gvnic" {
  type        = bool
  description = "Enable gvnic or not"
  default     = false
}

variable "node_pools_auto_repair" {
  type        = bool
  description = "Enable node pools auto repair"
  default     = true
}

variable "node_pools_auto_upgrade" {
  type        = bool
  description = "Enable node pools auto upgrade"
  default     = false
}

variable "node_pools_preemptible" {
  type        = bool
  description = "Node pools preemptible"
  default     = false
}

variable "node_pools_spot" {
  type        = bool
  description = "Enable node pools spot"
  default     = false
}

variable "node_pools_oauth_scopes" {
  type = map(list(string))
  description = " Map of lists containing node oauth scopes by node-pool name"
  default   = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
  
}

variable "node_pools_labels" {
  type = map(map(string))
  description = "Map of maps containing node labels by node-pool name"
  default = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }
}

variable "node_pools_metadata" {
  type = map(map(string))
  description = "Map of maps containing node metadata by node-pool name"
  default = { "all": {}, "default-node-pool": {} }

}

variable "node_pools_taints" {
  type = map(list(object({ key = string, value = string, effect = string })))
  description = " Map of lists containing node taints by node-pool name"
  default = { "all": [], "default-node-pool": [] }
  
}

variable "node_pools_tags" {
  type = map(list(string))
  description = "Map of lists containing node network tags by node-pool name"
  default = { "all": [], "default-node-pool": [] }
}