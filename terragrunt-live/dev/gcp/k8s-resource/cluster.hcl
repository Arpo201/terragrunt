terraform {
  source = "${get_path_to_repo_root()}/terragrunt-modules/k8s-resource/${basename(get_original_terragrunt_dir())}"
}

locals {

  namespace = {
    core      = "core"
    datastore = "datastore"
    tools     = "tools"
  }
}

inputs = {
  namespace                = local.namespace
}

# retryable_errors = ["Error:"]
# retry_max_attempts = 2
# retry_sleep_interval_sec = 30
