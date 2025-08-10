# This script is meant to be sourced, not executed.
# Usage:
#   . /path/to/lib-loader.sh
#   load_libs /path/to/lib

load_libs() {
	target_dir="$1"

	for script_file in "$target_dir"/*.lib.sh; do
		if [ -f "$script_file" ]; then
			# shellcheck source=/dev/null
			. "$script_file"
		fi
	done
}
