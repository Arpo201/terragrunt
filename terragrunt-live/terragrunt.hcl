terraform_version_constraint = ">= 1.9.3"
terragrunt_version_constraint = ">= 0.66.1"

terraform {
  before_hook "before_hook" {
    commands = ["apply", "plan", "destroy"]
    execute  = ["echo", "\n-----------------Running ${basename(get_original_terragrunt_dir())} terraform-----------------\n"]
  }

  after_hook "after_hook" {
    commands     = ["apply", "plan", "destroy"]
    execute      = ["echo", "\n-----------------Finished ${basename(get_original_terragrunt_dir())} terraform-----------------\n"]
    run_on_error = true
  }
}

locals {
  //  env_vars = {"environment":"XXX","provider":"XXX","provider_version":"XXXX","region":"XXX"}
  env_vars = merge(
    read_terragrunt_config(find_in_parent_folders("env.hcl")).locals,
    read_terragrunt_config(find_in_parent_folders("account.hcl")).locals,
    read_terragrunt_config(find_in_parent_folders("region.hcl")).locals
  )

  name_prefix = "project_a-${local.env_vars.environment}"
}

generate "local_provider" {
  path      = "local_provider.tf"
  disable   = local.env_vars.provider == "local" ? false : true
  if_exists = "overwrite"
  contents  = <<-EOF
    terraform {
        required_providers {
            local = {
            source = "hashicorp/local"
            version = "${local.env_vars.provider_version}"
            }
        }
    }

    provider "local" {
        # Configuration options
    }
  EOF
}

remote_state {
  disable_init = local.env_vars.provider == "local" ? false : true
  backend = "local"
  config = {
    path = "${get_repo_root()}/local-states/${split("/terragrunt-live/", get_original_terragrunt_dir())[1]}/terraform.tfstate"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
}

inputs = merge(local.env_vars, {
  name_prefix   = local.name_prefix
})


skip = true
