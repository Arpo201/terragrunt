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
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  environment   = local.environment_vars.locals.environment
  provider_info = local.account_vars.locals.provider_info

  name_prefix = "project_a-${local.environment}"

}

inputs = {
  # test = run_cmd("echo", "return: ", "${path_relative_to_include()}/terraform.tfstate")
  # echo = run_cmd("echo", "return: ", "${get_path_to_repo_root()}/terragrunt-modules${split("${local.region}", path_relative_to_include())[1]}")

  environment   = local.environment
  provider_info = local.provider_info
  name_prefix   = local.name_prefix
}

generate     = local.account_vars.generate
remote_state = local.account_vars.remote_state

skip = true
