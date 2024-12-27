generate "aws_provider" {
  path      = ""
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region = var.tg_env_vars.aws_region
  default_tags {}
}
EOF
}

generate "gcp" {
  path      = "google_provider.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    provider "google" {
      project     = "${local.provider_info.project_id}"
      region      = "${local.provider_info.region}"
      zone        = "${local.provider_info.zone}"
      credentials = file("${local.provider_info.credentials}")
    }
  EOF
}

provider "kubectl" {
  host                   = "https://${local.create_cluster ? dependency.cluster.outputs.endpoint : local.custom_endpoint}"
  cluster_ca_certificate = base64decode("${local.create_cluster ? dependency.cluster.outputs.ca_certificate : local.custom_ca_certificate}")
  token                  = data.google_client_config.default.access_token
  load_config_file       = false
}

provider "kubernetes" {
  host                   = "https://${local.create_cluster ? dependency.cluster.outputs.endpoint : local.custom_endpoint}"
  cluster_ca_certificate = base64decode("${local.create_cluster ? dependency.cluster.outputs.ca_certificate : local.custom_ca_certificate}")
  token                  = data.google_client_config.default.access_token
}

provider "helm" {
  kubernetes {
    host                   = "https://${local.create_cluster ? dependency.cluster.outputs.endpoint : local.custom_endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode("${local.create_cluster ? dependency.cluster.outputs.ca_certificate : local.custom_ca_certificate}")
  }
}
