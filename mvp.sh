#!/usr/bin/env bash

set -euo pipefail

./git_events_collector > /dev/null || nimble build

readonly ingest_url="${DW_INGEST_URL:=localhost:8080}"'/sqlite?sj_path={}&store=git-events'

./gec_rotate \
  | xargs -t ./gec_tsv-to-sqlite \
  | xargs -t ./gec_push \
  | xargs -t -I{} curl "${ingest_url}"
