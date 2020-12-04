#!/usr/bin/env bash

set -euo pipefail

readonly filepath="$1"

echo test-write | xargs -t uplink cp "${filepath}" 'sj://test/' --access | sed -E 's/^Created //'
