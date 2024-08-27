include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  modified_env = include.root.locals.environment
}
