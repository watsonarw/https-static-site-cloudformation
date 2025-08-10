# This script is meant to be sourced, not executed.

setup_color() {
	# Only use colors if connected to a terminal
	if [ -t 1 ]; then
		# Styles
		BOLD=$(printf '\033[1m')
		DIM=$(printf '\033[2m')
		ITALIC=$(printf '\033[3m')
		UNDERLINE=$(printf '\033[4m')
		BLINK=$(printf '\033[5m')
		INVERT=$(printf '\033[7m')
		STRIKETHROUGH=$(printf '\033[9m')

		# Foreground Colors
		RED=$(printf '\033[31m')
		GREEN=$(printf '\033[32m')
		YELLOW=$(printf '\033[33m')
		BLUE=$(printf '\033[34m')
		MAGENTA=$(printf '\033[35m')
		CYAN=$(printf '\033[36m')
		WHITE=$(printf '\033[37m')

		# Background Colors
		BG_RED=$(printf '\033[41m')
		BG_GREEN=$(printf '\033[42m')
		BG_YELLOW=$(printf '\033[43m')
		BG_BLUE=$(printf '\033[44m')
		BG_MAGENTA=$(printf '\033[45m')
		BG_CYAN=$(printf '\033[46m')
		BG_WHITE=$(printf '\033[47m')

		RESET=$(printf '\033[m')
	else
		BOLD=""
		DIM=""
		ITALIC=""
		UNDERLINE=""
		BLINK=""
		INVERT=""
		STRIKETHROUGH=""
		RED=""
		GREEN=""
		YELLOW=""
		BLUE=""
		MAGENTA=""
		CYAN=""
		WHITE=""
		BG_RED=""
		BG_GREEN=""
		BG_YELLOW=""
		BG_BLUE=""
		BG_MAGENTA=""
		BG_CYAN=""
		BG_WHITE=""
		RESET=""
	fi

	export BOLD DIM ITALIC UNDERLINE BLINK INVERT STRIKETHROUGH
	export RED GREEN YELLOW BLUE MAGENTA CYAN WHITE
	export BG_RED BG_GREEN BG_YELLOW BG_BLUE BG_MAGENTA BG_CYAN BG_WHITE
	export RESET
}

style() {
	text=""
	styles=""

	if [ ! -t 0 ]; then
		# Text from stdin, all arguments are styles
		text=$(cat)
		styles="$*"
	elif [ "$#" -eq 0 ]; then
		# No arguments, print newline, like echo
		printf '\n'
		return
	else
		# Last argument is text, the rest are styles
		while [ "$#" -gt 1 ]; do
			styles="${styles:+$styles }$1"
			shift
		done
		text="$1"
	fi

	# If not connected to terminal, just print text without formatting
	if [ ! -t 1 ]; then
		printf '%s\n' "$text"
		return
	fi

	codes=""

	for style in $styles; do
		case "$style" in
			bold) codes="${codes:+$codes;}1" ;;
			dim) codes="${codes:+$codes;}2" ;;
			italic) codes="${codes:+$codes;}3" ;;
			underline) codes="${codes:+$codes;}4" ;;
			blink) codes="${codes:+$codes;}5" ;;
			invert) codes="${codes:+$codes;}7" ;;
			strikethrough) codes="${codes:+$codes;}9" ;;
			red) codes="${codes:+$codes;}31" ;;
			green) codes="${codes:+$codes;}32" ;;
			yellow) codes="${codes:+$codes;}33" ;;
			blue) codes="${codes:+$codes;}34" ;;
			magenta) codes="${codes:+$codes;}35" ;;
			cyan) codes="${codes:+$codes;}36" ;;
			white) codes="${codes:+$codes;}37" ;;
			bg_red) codes="${codes:+$codes;}41" ;;
			bg_green) codes="${codes:+$codes;}42" ;;
			bg_yellow) codes="${codes:+$codes;}43" ;;
			bg_blue) codes="${codes:+$codes;}44" ;;
			bg_magenta) codes="${codes:+$codes;}45" ;;
			bg_cyan) codes="${codes:+$codes;}46" ;;
			bg_white) codes="${codes:+$codes;}47" ;;
		esac
	done

	printf '%s\n' "$text" | while IFS= read -r line; do
		printf '\033[%sm%s%s\n' "$codes" "$line" "$RESET"
	done
}

setup_color
