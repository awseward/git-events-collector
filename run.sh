#!/usr/bin/env bash

set -euo pipefail

nimble build

# readonly id="$(mktemp | xargs basename | sed -e 's/\./_/g')"
readonly sqlite_filepath="$(./git_events_collector mvp)"
readonly dw_db_name='warehouse'
readonly load_file="$(mktemp)"

createdb "${dw_db_name}" || true

dhall text <<< "./pgLoad.dhall \"${sqlite_filepath}\" \"${dw_db_name}\"" \
  | tee "${load_file}"

pgloader "${load_file}"
