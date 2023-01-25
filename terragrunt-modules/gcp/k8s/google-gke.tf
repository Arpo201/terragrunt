# client_config and kubernetes provider must be explicitly specified like the following.
module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  kubernetes_version         = var.k8s_version
  project_id                 = var.provider_info.project_id
  name                       = var.cluster_name
  region                     = var.provider_info.region
  zones                      = [var.provider_info.zone]
  network                    = var.vpc_name
  subnetwork                 = var.vpc_subnetwork_names[0]
  ip_range_pods              = var.vpc_subnets_secondary_ranges[0][0].range_name
  ip_range_services          = var.vpc_subnets_secondary_ranges[0][1].range_name
  http_load_balancing        = var.http_load_balancing       
  network_policy             = var.network_policy            
  horizontal_pod_autoscaling = var.horizontal_pod_autoscaling
  filestore_csi_driver       = var.filestore_csi_driver      
  enable_private_endpoint    = var.enable_private_endpoint   
  enable_private_nodes       = var.enable_private_nodes      
  remove_default_node_pool   = var.remove_default_node_pool  

  node_pools = [
    {
      name               = var.pool_name
      machine_type       = var.pool_machine_type
      node_locations     = var.provider_info.zone
      min_count          = var.pool_min_node
      max_count          = var.pool_max_node
      local_ssd_count    = var.node_pools_local_ssd_count 
      spot               = var.node_pools_spot            
      disk_size_gb       = var.pool_disk_size_gb
      disk_type          = var.pool_disk_type
      image_type         = var.pool_image_type
      enable_gcfs        = var.node_pools_enable_gcfs 
      enable_gvnic       = var.node_pools_enable_gvnic
      auto_repair        = var.node_pools_auto_repair 
      auto_upgrade       = var.node_pools_auto_upgrade
      service_account    = var.service_account
      preemptible        = var.node_pools_preemptible
      initial_node_count = var.pool_init_node
    },
  ]

  node_pools_oauth_scopes = var.node_pools_oauth_scopes

  node_pools_labels = var.node_pools_labels

  node_pools_metadata = var.node_pools_metadata

  node_pools_taints = var.node_pools_taints

  node_pools_tags = var.node_pools_tags
}
