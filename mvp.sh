#!/usr/bin/env bash

set -euo pipefail

git_events_collector > /dev/null || nimble build

repo_dir="$(realpath -e "${0}" | xargs dirname)"; readonly repo_dir

>&2 echo -e "Running with ${repo_dir} at front of \$PATH...\n"

PATH="${repo_dir}:${PATH}" "${repo_dir}/gec" run
