module "cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 0.4"

  name    = var.cloud_router_name
  project = var.provider_info.project_id
  region  = var.provider_info.region
  network = var.network_name
  
  depends_on = [
    module.vpc
  ]
}

module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 1.2"
  project_id = var.provider_info.project_id
  region     = var.provider_info.region
  router     = var.cloud_router_name

  depends_on = [
    module.cloud_router
  ]
}