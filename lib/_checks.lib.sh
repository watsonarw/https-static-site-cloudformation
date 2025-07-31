# This script is meant to be sourced, not executed.

command_exists() {
  type "$1" &>/dev/null
}

require_argument() {
  local option_name="$1"
  local option_value="$2"
  if [[ -z "$option_value" || "$option_value" =~ ^- ]]; then
    echo "Error: Argument for $option_name is missing or invalid" >&2
    exit 1
  fi
}
