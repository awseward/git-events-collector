#!/usr/bin/env bash

set -euo pipefail

readonly closed_log="$(./rotate.sh)"

./load_pg.sh "${closed_log}"
