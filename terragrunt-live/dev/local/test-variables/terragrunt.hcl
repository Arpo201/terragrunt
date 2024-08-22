terraform {
  // Output example : source = "/Users/test/terragrunt/terragrunt-modules/local/test-variables"
  source = "${replace(replace(get_terragrunt_dir(), "terragrunt-live", "terragrunt-modules"), "${include.root.locals.environment}", "")}"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  echo = run_cmd("echo", "${replace(replace(get_terragrunt_dir(), "terragrunt-live", "terragrunt-modules"), "/${include.root.locals.environment}", "")}")
}


inputs = {
  data = {
    hello = "test"
  }
}