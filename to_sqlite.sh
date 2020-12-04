#!/usr/bin/env bash

set -euo pipefail

readonly closed_log="$1"

# Check if there's even anything in it
if [ -s "${closed_log}" ]; then
  readonly sqlite_filepath="$(mktemp).db"

  ./git_events_collector mvp "${closed_log}" "${sqlite_filepath}"
  rm -f "${closed_log}"
else
  >&2 echo "empty file ${closed_log} -- doing nothing"
  rm -f "${closed_log}"
  exit 1
fi

