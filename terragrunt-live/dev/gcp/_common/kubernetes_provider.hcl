locals {
  env_vars              = read_terragrunt_config("${dirname(find_in_parent_folders("account.hcl"))}/_common/_env.hcl")
  create_cluster        = local.env_vars.locals.create_cluster
  custom_cluster_name   = local.env_vars.locals.custom_cluster_name
  custom_endpoint       = local.env_vars.locals.custom_endpoint
  custom_ca_certificate = local.env_vars.locals.custom_ca_certificate
}

generate "kubernetes_provider" {
  path      = "kubernetes_provider.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    provider "kubernetes" {
      host                   = "https://${local.create_cluster ? dependency.cluster.outputs.endpoint : local.custom_endpoint}"
      cluster_ca_certificate = base64decode("${local.create_cluster ? dependency.cluster.outputs.ca_certificate : local.custom_ca_certificate}")
      token                  = data.google_client_config.default.access_token
    }
  EOF
}
