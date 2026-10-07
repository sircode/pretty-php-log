#!/bin/bash

# ----------------------
# pretty-php-log v1
# ----------------------

# --- Default values ---
USE_EMOJI=false
LOGFILE=""
KEYWORD=""
LEVEL=""
STRIP_PATH=""
OUTPUT=""
MAX_LINES=0

# --- Color codes ---
RED=$'\033[0;31m'
LIGHT_RED='\033[1;91m'
ALARM_RED='\033[38;5;196m'
YELLOW=$'\033[1;33m'
MAGENTA=$'\033[1;35m'
BLUE='\033[0;34m'
LIGHT_BLUE='\033[1;34m'
NOTICE_BLUE='\033[38;5;39m'
CYAN=$'\033[0;36m'
NC=$'\033[0m'

show_help() {
    echo "Usage: $0 -f <logfile> [options]"
    echo ""
    echo "Options:"
    echo "  -f, --file         Path to the log file (required)"
    echo "  -k, --filter       Filter by keyword (e.g. 'Undefined')"
    echo "  -l, --level        Filter by log level: warning, fatal, parse"
    echo "  -s, --strip-path   Path prefix to strip from filenames"
    echo "  -e, --emoji        Enable emoji output"
    echo "      --no-emoji     Disable emoji output (default)"
    echo "  -o, --output       Write formatted output to a file"
    echo "  -m, --max-lines    Show last N lines before live tailing"
    echo "  -h, --help         Show this help message"
    exit 1
}

# --- Parse args ---
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--file) LOGFILE="$2"; shift ;;
        -k|--filter) KEYWORD="$2"; shift ;;
        -l|--level) LEVEL="$2"; shift ;;
        -s|--strip-path) STRIP_PATH="$2"; shift ;;
        -e|--emoji) USE_EMOJI=true ;;
        --no-emoji) USE_EMOJI=false ;;
        -o|--output) OUTPUT="$2"; shift ;;
        -m|--max-lines) MAX_LINES="$2"; shift ;;
        -h|--help) show_help ;;
        *) echo "Unknown option: $1"; show_help ;;
    esac
    shift
done

# --- Validate required ---
if [[ -z "$LOGFILE" ]]; then
    echo "Error: Log file must be specified with --file"
    exit 1
fi

if [[ ! -f "$LOGFILE" ]]; then
    echo "Error: Log file not found: $LOGFILE"
    exit 1
fi

# --- Output function (optional file) ---
print_line() {
    echo -e "$1"
    [[ -n "$OUTPUT" ]] && echo -e "$(echo "$1" | sed 's/\x1B\[[0-9;]*[JKmsu]//g')" >> "$OUTPUT"
}

# --- Initial output if requested ---
if [[ "$MAX_LINES" -gt 0 ]]; then
    tail -n "$MAX_LINES" "$LOGFILE"
    echo -e "\n--- Live Tail Starting ---"
fi

tail -F "$LOGFILE" | while IFS= read -r line; do
    [[ -n "$STRIP_PATH" ]] && line="${line//$STRIP_PATH/}"
    line=$(echo "$line" | perl -pe 's/PHP message:\s*(PHP (Warning|Notice|Fatal error|Parse error):)/\n$1/g')

    while IFS= read -r subline; do
        [[ -z "$subline" ]] && continue

        # --- Filter by keyword ---
        if [[ -n "$KEYWORD" && "$subline" != *"$KEYWORD"* ]]; then
            continue
        fi

        # --- Filter by level ---
        if [[ -n "$LEVEL" ]]; then
            case "$LEVEL" in
                warning) [[ "$subline" != *"PHP Warning:"* ]] && continue ;;
                fatal) [[ "$subline" != *"PHP Fatal error:"* ]] && continue ;;
                parse) [[ "$subline" != *"PHP Parse error:"* ]] && continue ;;
            esac
        fi

        # --- Add prefix/icon ---
        prefix=""
        if [[ "$subline" == *"PHP Warning:"* ]]; then
            prefix=$([[ $USE_EMOJI == true ]] && echo "⚠️  " || echo "${YELLOW}[WARNING]${NC} ")
        elif [[ "$subline" == *"PHP Fatal error:"* ]]; then
            prefix=$([[ $USE_EMOJI == true ]] && echo "🔴 " || echo "${LIGHT_RED}[FATAL]${NC} ")
        elif [[ "$subline" == *"PHP Parse error:"* ]]; then
            prefix=$([[ $USE_EMOJI == true ]] && echo "🛑 " || echo "${ALARM_RED}[PARSE]${NC} ")
        elif [[ "$subline" == *"PHP Notice:"* ]]; then
            prefix=$([[ $USE_EMOJI == true ]] && echo "ℹ️  " || echo "${NOTICE_BLUE}[NOTICE]${NC} ")
        fi

        # --- Highlight ---
        subline=$(echo "$subline" | perl -pe "s/(\\[[^]]+\\])/${YELLOW}\1${NC}/g")
        [[ -n "$KEYWORD" ]] && subline=$(echo "$subline" | perl -pe "s/($KEYWORD)/${RED}\1${NC}/ig")
        subline=$(echo "$subline" | perl -pe "s/(\\\$\\w+)/${CYAN}\1${NC}/g")
        subline=$(echo "$subline" | perl -pe "s/(\"[^\"]+\")/${MAGENTA}\1${NC}/g")

        # --- Print ---
        print_line "${prefix}${subline}"
    done <<< "$line"
done



# Basic
#./pretty-php-log.sh -f ~/logs/error_log

# Filter for 'Undefined' and trim path
#./pretty-php-log.sh -f ~/logs/error_log -k Undefined -s "/var/www/html/"

# Emoji + show only 'fatal' errors
#./pretty-php-log.sh -f ~/logs/error_log -l fatal -e

# Show last 100 lines, then live-tail and log to file
#./pretty-php-log.sh -f ~/logs/error_log -m 100 -o ~/pretty-clean.log
