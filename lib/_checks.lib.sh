# This script is meant to be sourced, not executed.

command_exists() {
  type "$1" &>/dev/null
}

check_dependencies() {
  if ! command_exists aws; then
    style red <<-EOF
You need aws-cli to run this!
For instructions on how to install it, see:
https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-set-up.html
EOF
    exit 1
  fi
}

require_argument() {
  local option_name="$1"
  local option_value="$2"
  if [[ -z "$option_value" || "$option_value" =~ ^- ]]; then
    style red "Error: Argument for $option_name is missing or invalid" >&2
    exit 1
  fi
}

warn_if_conflict() {
  local arg_name="$1"
  local existing_value="$2"
  local custom_message="${3:-}"

  if [ -n "$existing_value" ]; then
    style yellow "Warning: ${custom_message:-$arg_name specified multiple times. Using last value.}" >&2
  fi
}
