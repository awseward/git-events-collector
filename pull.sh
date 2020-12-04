#!/usr/bin/env bash

set -euo pipefail

readonly url="$1"
readonly sqlite_filepath="$(mktemp).db"
readonly sj_access="${SJ_ACCESS:-test-read}"

echo "${sj_access}" | xargs -t >&2 uplink cp "${url}" "${sqlite_filepath}" --access

echo "${sqlite_filepath}"
