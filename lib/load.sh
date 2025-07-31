# This script is meant to be sourced, not executed.

SCRIPT_NAME=$(basename "${0}")
readonly SCRIPT_NAME
export SCRIPT_NAME
PROJECT_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
readonly PROJECT_ROOT
export PROJECT_ROOT
SCRIPT_DIR=$(cd "$(dirname "${0}")" && pwd)
readonly SCRIPT_DIR
export SCRIPT_DIR

_source_all_files() {
  local scripts_glob=$1

  for SCRIPT in $scripts_glob; do
    if [ -f "$SCRIPT" ]; then
      # shellcheck source=/dev/null
      . "$SCRIPT"
    fi
  done
}

_source_all_files "${PROJECT_ROOT}/lib/*.lib.sh"

unset -f _source_all_files
