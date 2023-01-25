locals {
  provider_info = {
    cloud_provider = "gcp",
    credentials    = "${get_parent_terragrunt_dir()}/credential.json"
    project_id     = "project_a-dev"
    region         = "asia-southeast1"
    zone           = "asia-southeast1-a"
  }
}

generate "provider" {
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

remote_state {
  backend = "gcs"
  config = {
    bucket      = "project_a-dev-test-terragrunt-tf-state"
    prefix      = "${split("/terragrunt-live/", get_original_terragrunt_dir())[1]}/terraform.tfstate"
    project     = "${local.provider_info.project_id}"
    location    = "${local.provider_info.region}"
    credentials = "${local.provider_info.credentials}"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
}
