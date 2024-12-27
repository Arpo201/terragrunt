# Inject dynamic child variables into template variables

## Tree

```sh
.
├── _common
│   ├── resources
│   │   ├── aws
│   │   │   └── s3
│   │   │       └── common.hcl
│   │   └── null
│   │       └── common.hcl
│   └── scripts
│       └── tg-render.bash
├── aws
│   ├── _common
│   └── dev
│       └── s3
│           └── test
│               └── terragrunt.hcl
└── terragrunt.hcl
```

## \_common: tg-render.bash

```bash
#!/bin/bash

set -e

tg_dir_path="$1"
tg_out_file_path="$2"

mkdir -p $(dirname $tg_out_file_path)
terragrunt render-json --terragrunt-working-dir "$tg_dir_path" --terragrunt-json-out "$tg_out_file_path" 1>&/dev/null

cat $tg_out_file_path

```

## \_common: template.hcl

```hcl
locals {
  root_path     = abspath(dirname(find_in_parent_folders()))
  tg_dir_path   = abspath(get_terragrunt_dir())

  tg_render_path = "${local.tg_dir_path}/.terragrunt-cache/terragrunt-render.json"
  tg_render_str  = run_cmd("--terragrunt-quiet", "${local.root_path}/_common/scripts/tg-render.bash", "${local.tg_dir_path}", "${local.tg_render_path}")
  tg_render_vars = jsondecode(local.tg_render_str)
  vars = {
    allow_role_arns = try(local.tg_render_vars.inputs.allow_role_arns, [])
  }
}
```

## child: terragrunt.hcl

```hcl
inputs = {
  allow_role_arns = [for id in local.accounts : "arn:aws:iam::${id}:role${local.env_vars.aws_region}/reader_*"]
}

locals {}

include "root" {
  path           = find_in_parent_folders()
  merge_strategy = "deep"
  expose         = true
}

include "template_s3_config" {
  path           = get_terraform_command() == "render-json" ? "${get_repo_root()}/${dirname(find_in_parent_folders())}/_common/resources/null/null-common.hcl" : "${get_repo_root()}/${dirname(find_in_parent_folders())}/_common/resources/aws/s3/s3-common.hcl"
  merge_strategy = "deep"
  expose         = true
}
```

## root: terragrunt.hcl

```hcl
locals {}
```
