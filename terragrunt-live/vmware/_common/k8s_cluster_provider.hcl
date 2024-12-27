locals {
  env_vars              = read_terragrunt_config("${dirname(find_in_parent_folders("account.hcl"))}/_common/_env.hcl")
  create_cluster        = local.env_vars.locals.create_cluster
  custom_cluster_name   = local.env_vars.locals.custom_cluster_name
  custom_endpoint       = local.env_vars.locals.custom_endpoint
  custom_ca_certificate = local.env_vars.locals.custom_ca_certificate
}

dependency "cluster" {
  skip_outputs = !local.create_cluster # if true, use mocks be output

  # result: /terragrunt-live/dev/gcp/asia-southeast1/k8s
  config_path = "${dirname(find_in_parent_folders("account.hcl"))}/k8s"

  mock_outputs = {
    endpoint               = "fake-enpoint"
    cluster_name           = "fake-cluster-name"
    cluster_ca_certificate = "fake-cluster_ca_certificate"
    client_certificate     = "fake-client_certificate"
    client_key             = "fake-client_key"
    ca_certificate         = "fake-certificate"
  }
}

generate "k8s_cluster_provider" {
  path      = "k8s_cluster_provider.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    provider "kubectl" {
      config_path = "~/.kube/config"
    }

    provider "helm" {
      kubernetes {
        config_path = "~/.kube/config"
      }
    }
  EOF
}

inputs = {
  k8s_cluster_name           = local.create_cluster ? dependency.cluster.outputs.cluster_name : local.custom_cluster_name
  k8s_cluster_endpoint       = local.create_cluster ? dependency.cluster.outputs.endpoint : local.custom_endpoint
  k8s_cluster_ca_certificate = local.create_cluster ? dependency.cluster.outputs.ca_certificate : local.custom_ca_certificate
}
