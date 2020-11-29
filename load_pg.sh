#!/usr/bin/env bash

set -euo pipefail

readonly closed_log="$1"

# Check if there's even anything in it
if [ -s "${closed_log}" ]; then
  readonly dw_db_name='warehouse'
  readonly sqlite_filepath="$(mktemp).db"

  ./git_events_collector mvp "${closed_log}" "${sqlite_filepath}"

  createdb "${dw_db_name}" || true

  readonly load_file="$(mktemp)"
  dhall text <<< "./pgLoad.dhall \"${sqlite_filepath}\" \"${dw_db_name}\"" \
    | tee "${load_file}"
  pgloader "${load_file}"
else
  >&2 echo "empty file ${closed_log} -- doing nothing"
fi

rm -f "${closed_log}"
