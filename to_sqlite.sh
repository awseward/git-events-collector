#!/usr/bin/env bash

set -euo pipefail

readonly tsv_log="$1"

# Check if there's even anything in it
if [ -s "${tsv_log}" ]; then
  readonly sqlite_filepath="$(mktemp).db"

  ./git_events_collector mvp "${tsv_log}" "${sqlite_filepath}"
  rm -f "${tsv_log}"
else
  >&2 echo "empty file ${tsv_log} -- doing nothing"
  rm -f "${tsv_log}"
  exit 1
fi
