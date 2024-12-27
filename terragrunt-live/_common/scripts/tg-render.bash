#!/bin/bash

set -e

tg_dir_path="$1"
tg_out_file_path="$2"

mkdir -p $(dirname $tg_out_file_path)
terragrunt render-json --terragrunt-working-dir "$tg_dir_path" --terragrunt-json-out "$tg_out_file_path" 1>&/dev/null

cat $tg_out_file_path
