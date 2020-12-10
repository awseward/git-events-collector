#!/usr/bin/env bash

set -euo pipefail

git_events_collector > /dev/null || nimble build

readonly repo_dir="$(realpath -e "${0}" | xargs dirname)"

>&2 echo -e "Running with ${repo_dir} at front of \$PATH...\n"

PATH="${repo_dir}:${PATH}" "${repo_dir}/gec_run"
