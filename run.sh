#!/usr/bin/env bash

set -euo pipefail

readonly dw_db_name='warehouse'
readonly sqlite_filepath="$(mktemp).db"

./git_events_collector mvp ~/.git-events.log "${sqlite_filepath}"

createdb "${dw_db_name}" || true

readonly load_file="$(mktemp)"
dhall text <<< "./pgLoad.dhall \"${sqlite_filepath}\" \"${dw_db_name}\"" \
  | tee "${load_file}"
pgloader "${load_file}"
