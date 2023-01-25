locals {
  env_vars              = read_terragrunt_config("${dirname(find_in_parent_folders("account.hcl"))}/_common/_env.hcl")
  create_cluster        = local.env_vars.locals.create_cluster
  custom_cluster_name   = local.env_vars.locals.custom_cluster_name
  custom_endpoint       = local.env_vars.locals.custom_endpoint
  custom_ca_certificate = local.env_vars.locals.custom_ca_certificate
}

dependency "cluster" {
  skip_outputs = !local.create_cluster # if true, use mocks be output

  # result: /terragrunt-live/dev/gcp/k8s
  config_path = "${dirname(find_in_parent_folders("account.hcl"))}/k8s"

  mock_outputs = {
    cluster_name   = "fake-cluster-name"
    endpoint       = "fake-enpoint"
    ca_certificate = "fake-certificate"
  }
}

generate "k8s_cluster_provider" {
  path      = "kubectl_helm_provider.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    provider "kubectl" {
      host                   = "https://${local.create_cluster ? dependency.cluster.outputs.endpoint : local.custom_endpoint}"
      cluster_ca_certificate = base64decode("${local.create_cluster ? dependency.cluster.outputs.ca_certificate : local.custom_ca_certificate}")
      token                  = data.google_client_config.default.access_token
      load_config_file       = false
    }

    provider "helm" {
      kubernetes {
        host                   = "https://${local.create_cluster ? dependency.cluster.outputs.endpoint : local.custom_endpoint}"
        token                  = data.google_client_config.default.access_token
        cluster_ca_certificate = base64decode("${local.create_cluster ? dependency.cluster.outputs.ca_certificate : local.custom_ca_certificate}")
      }
    }

    data "google_client_config" "default" {}
  EOF
}

inputs = {
  k8s_cluster_name           = local.create_cluster ? dependency.cluster.outputs.cluster_name : local.custom_cluster_name
  k8s_cluster_endpoint       = local.create_cluster ? dependency.cluster.outputs.endpoint : local.custom_endpoint
  k8s_cluster_ca_certificate = local.create_cluster ? dependency.cluster.outputs.ca_certificate : local.custom_ca_certificate
}
