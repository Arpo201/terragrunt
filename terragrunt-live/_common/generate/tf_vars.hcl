# Use only contents attribute
generate "tg_vars" {
  # description: Inject local.env_vars to terraform layer
  path      = ""
  if_exists = "overwrite"
  contents  = <<EOF
variable "tg_env_vars" {
  description = "Variables from terragrunt"
  type = any
  default = {}
}
EOF
}
