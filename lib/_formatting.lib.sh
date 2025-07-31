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
}

style() {
  local text
  local styles

  if [ ! -t 0 ]; then
    text=$(cat)
    styles=("$@")
  elif [ "$#" -eq 0 ]; then
    return
  else
    text="${@: -1}"
    styles=("${@:1:$#-1}")
  fi

  if ! [ -t 1 ]; then
    printf '%s\n' "$text"
    return
  fi

  local codes=()
  for s in "${styles[@]:-}"; do
    case "$s" in
    bold) codes+=('1') ;;
    dim) codes+=('2') ;;
    italic) codes+=('3') ;;
    underline) codes+=('4') ;;
    blink) codes+=('5') ;;
    invert) codes+=('7') ;;
    strikethrough) codes+=('9') ;;
    red) codes+=('31') ;;
    green) codes+=('32') ;;
    yellow) codes+=('33') ;;
    blue) codes+=('34') ;;
    magenta) codes+=('35') ;;
    cyan) codes+=('36') ;;
    white) codes+=('37') ;;
    bg_red) codes+=('41') ;;
    bg_green) codes+=('42') ;;
    bg_yellow) codes+=('43') ;;
    bg_blue) codes+=('44') ;;
    bg_magenta) codes+=('45') ;;
    bg_cyan) codes+=('46') ;;
    bg_white) codes+=('47') ;;
    esac
  done

  local joined_codes=$(IFS=';'; echo "${codes[*]:-}")

  local line
  while IFS= read -r line; do
    printf '\033[%sm%s%b\n' "$joined_codes" "$line" "$RESET"
  done <<<"$text"
}

setup_color
