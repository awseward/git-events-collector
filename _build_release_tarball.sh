#!/usr/bin/env bash

set -euo pipefail

set -x

readonly tag_name="$1"
readonly binary_name='git_events_collector'
readonly tarball_name="${binary_name}-${tag_name}.tar.gz"

>&2 nimble build --accept --define:release
>&2 tar -czf "${tarball_name}" \
                           "${binary_name}" \
                           gec_rotate \
                           gec_tsv-to-sqlite \
                           gec_push

echo "${tarball_name}"
