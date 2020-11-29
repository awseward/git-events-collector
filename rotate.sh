#!/usr/bin/env bash

set -euo pipefail

base_dir="${RUN_BASE_DIR:-$HOME}"
readonly base_dir="$(realpath "${base_dir}")"

readonly logs_dir="${base_dir}/.git-events";    mkdir -p "${logs_dir}"
readonly logs_dir_outbox="${logs_dir}/_outbox"; mkdir -p "${logs_dir_outbox}"
readonly log_ln="${base_dir}/.git-events.log"

_close_log() {
  local -r src="$1"
  local -r dest="${logs_dir_outbox}/$(basename "${src}")"

  chmod -w "${src}"
  mv "${src}" "${dest}"
  echo "${dest}"
}

# Set up and exit if nothing found
if [ ! -f "${log_ln}" ]; then
  >&2 echo "${log_ln} does not exist -- setting it up"

  readonly log_new="${logs_dir}/$(date +%s).log"
  touch "${log_new}"
  ln -fs "${log_new}" "${log_ln}"

  >&2 echo "current log: ${log_new}"
  exit
fi

log_active="$(readlink -f "${log_ln}")"

if [ "${log_ln}" = "${log_active}" ]; then
  >&2 echo "${log_ln} is not a symlink -- making it one"

  migrated_log="${logs_dir}/migrated-$(date +%s).log"
  mv "${log_ln}" "${migrated_log}"
  ln -fs "${migrated_log}" "${log_ln}"
fi

log_active="$(readlink -f "${log_ln}")"

### Rotation

log_inactive="${log_active}"

# Point symlink at new file
readonly log_new="${logs_dir}/$(date +%s).log"
touch "${log_new}"
ln -fs "${log_new}" "${log_ln}"

_close_log "${log_inactive}"
