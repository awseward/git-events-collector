#!/usr/bin/env bash

set -euo pipefail

base_dir="${RUN_BASE_DIR:-$HOME}"
readonly base_dir="$(realpath "${base_dir}")"

readonly logs_dir="${base_dir}/.git-events";   mkdir -p "${logs_dir}"
readonly logs_dir_closed="${logs_dir}/_closed"; mkdir -p "${logs_dir_closed}"

readonly well_known_ln_path="${base_dir}/.git-events.log"
current_log="$(readlink -f "${well_known_ln_path}")"

if [ ! -f "${well_known_ln_path}" ]; then
  >&2 echo "${well_known_ln_path} does not exist -- setting it up"

  readonly new_log="${logs_dir}/$(date +%s).log"
  touch "${new_log}"
  ln -fs "${new_log}" "${well_known_ln_path}"

  readonly current_log="$(readlink -f "${well_known_ln_path}")"
  >&2 echo "current log: ${current_log}"
  exit
fi

# ---

if [ "${well_known_ln_path}" = "${current_log}" ]; then
  >&2 echo "${well_known_ln_path} is not a symlink -- making it one"

  migrated_log="${logs_dir}/migrated-$(date +%s).log"
  mv "${well_known_ln_path}" "${migrated_log}"
  ln -fs "${migrated_log}" "${well_known_ln_path}"
fi

current_log="$(readlink -f "${well_known_ln_path}")"
>&2 echo "current log: ${current_log}"

### Rotation

# Point symlink at new file
readonly new_log="${logs_dir}/$(date +%s).log"
touch "${new_log}"
ln -fs "${new_log}" "${well_known_ln_path}"

# Close old log
chmod -w "${current_log}"

# Move old log to closed dir
readonly closed_log="${logs_dir_closed}/$(basename "${current_log}")"
mv "${current_log}" "${closed_log}"

sleep 5

readonly dw_db_name='warehouse'
readonly sqlite_filepath="$(mktemp).db"

./git_events_collector mvp "${closed_log}" "${sqlite_filepath}"

createdb "${dw_db_name}" || true

readonly load_file="$(mktemp)"
dhall text <<< "./pgLoad.dhall \"${sqlite_filepath}\" \"${dw_db_name}\"" \
  | tee "${load_file}"
pgloader "${load_file}" && rm -f "${closed_log}"
