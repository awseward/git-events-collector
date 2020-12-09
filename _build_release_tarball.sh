#!/usr/bin/env bash

set -euo pipefail

set -x

readonly tag_name="$1"
readonly binary_name='git_events_collector'
readonly tarball_name="${binary_name}-${tag_name}.tar.gz"

echo | xargs -t >&2 nimble build --accept --define:release
echo | xargs -t >&2 tar -czf "${tarball_name}" \
                           "${binary_name}" \
                           rotate.sh \
                           to_sqlite.sh \
                           push.sh

echo "${tarball_name}"
