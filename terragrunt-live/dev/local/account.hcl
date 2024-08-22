locals {
  provider_info = {
    cloud_provider = "local"
  }
}

remote_state {
  backend = "local"
  config = {
    path = "${get_repo_root()}/local-states/${split("/terragrunt-live/", get_original_terragrunt_dir())[1]}/terraform.tfstate"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }

}
