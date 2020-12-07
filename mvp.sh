#!/usr/bin/env bash

set -euo pipefail

./git_events_collector || nimble build

readonly ingest_url="${DW_INGEST_URL:=localhost:8080}"'/sqlite?sj_path={}&store=git-events'

./rotate.sh \
  | xargs -t ./to_sqlite.sh \
  | xargs -t ./push.sh \
  | xargs -t -I{} curl "${ingest_url}"
