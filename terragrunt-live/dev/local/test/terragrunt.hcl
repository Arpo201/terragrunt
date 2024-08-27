terraform {
  // Output example : source = "/Users/test/terragrunt/terragrunt-modules/local/test-variables"
  source = "${replace(replace(get_terragrunt_dir(), "terragrunt-live", "terragrunt-modules"), "${include.root.locals.environment}", "")}"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  config = read_terragrunt_config(find_in_parent_folders("${dirname(find_in_parent_folders("account.hcl"))}/_common/modified-root-vars.hcl"))
  echo   = run_cmd("echo", "${local.config.locals.modified_env}")
}


inputs = {
  data = {
    hello = "test"
  }
}