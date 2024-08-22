terraform {
  // Output example : source = "/Users/test/terragrunt/terragrunt-modules/local/test-variables"
  source = "${replace(replace(get_terragrunt_dir(), "terragrunt-live", "terragrunt-modules"), "${include.root.locals.environment}", "")}"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "env_vars" {
  path   = "${dirname(find_in_parent_folders("account.hcl"))}/_common/_env.hcl"
  expose = true
}

include "network_dependency" {
  path = find_in_parent_folders("${dirname(find_in_parent_folders("account.hcl"))}/_common/network_dependency.hcl")
}

inputs = {
  service_account   = "terraform@project.iam.gserviceaccount.com"
  cluster_name      = "${include.root.locals.name_prefix}-project-cluster"
  k8s_version       = "1.24.8-gke.401"
  pool_name         = "a-node-pool"
  pool_machine_type = "e2-standard-2"
  pool_disk_type    = "pd-standard"
  pool_disk_size_gb = 50
  pool_image_type   = "COS_CONTAINERD"
  pool_min_node     = 2
  pool_max_node     = 3
  pool_init_node    = 2
  http_load_balancing        = false
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false
  enable_private_endpoint    = false
  enable_private_nodes       = true
  remove_default_node_pool   = true
  node_pools_enable_gcfs     = false
  node_pools_enable_gvnic    = false
  node_pools_auto_repair     = true
  node_pools_auto_upgrade    = true
  node_pools_preemptible     = false
  node_pools_local_ssd_count = 0
  node_pools_spot            = false
  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "a-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}

skip = !include.env_vars.locals.create_cluster
