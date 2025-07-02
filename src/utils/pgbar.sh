#!/bin/bash

# --------------------------------------------------------------------------------
# src/utils/progress.sh
# Progress Bar
#
# Progress bar with spinner, percentage display, and estimated time of arrival
# (ETA). It displays in full color with a Braille spinner and a filled bar.
# --------------------------------------------------------------------------------

source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/tui.sh"

# Progress bar config
DRAW_INTERVAL_NS=50000000
SPINNER_CHARS=( "⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏" )
BAR_FILLER="■"
BAR_EMPTY=" "
ROW=$(( ROWS - 5 ))
LEN=$(( LENGTH - 22 ))

# Status vars
START_TIME=0
LAST_DRAW_NS=0
SPINNER_INDEX=0
TOTAL_ITEMS=0
ETA="--:--:--"

# Initialize the progress bar
# Set start time, total items to count and reset spinner index
pgbar_init () {

    START_TIME=$( date +%s )
    LAST_DRAW_NS=0
    SPINNER_INDEX=0
    TOTAL_ITEMS=$1
    ETA="--:--:--"

    pgbar_update 0

}

# Hide / remove the progress bar
pgbar_clear () {
    set_line $ROW
}

# Update (draw) progress bar
# Will automatically calculate ETA, progress and bar
pgbar_update () {

    local now_ns=$( date +%s%N )
    local delta=$(( now_ns - LAST_DRAW_NS ))

    if (( delta < DRAW_INTERVAL_NS )); then return; fi

    LAST_DRAW_NS=$now_ns

    # Calculate the current progress
    local now_s=$( date +%s )
    local elapsed=$(( now_s - START_TIME ))
    local cur=$1

    # Get the current spinner character
    local spinner=${SPINNER_CHARS[SPINNER_INDEX]}

    # Update the spinner index
    # Wrap around if it exceeds the length of the spinner array
    SPINNER_INDEX=$(( ( SPINNER_INDEX + 1 ) % ${#SPINNER_CHARS[@]} ))

    # Calculate the percentage and remaining time
    local pct=$(( cur * 100 / TOTAL_ITEMS ))

    if (( SPINNER_INDEX % 50 == 0 && cur > 0 )); then
        local eta=$(( elapsed * ( TOTAL_ITEMS - cur ) / cur ))
        ETA=$( date -u -d "@$eta" +%H:%M:%S )
    fi

    # Calculate progress bar fill and empty parts
    local fill=$(( pct * LEN / 100 ))
    local empty=$(( LEN - fill ))

    # Clear the progress bar
    pg_clear

    # Output the formatted progress bar
    printf "%s%s%s%s %3d%% [%s%s] ETA %s" \
        "$PRFX" "$CYAN" "$spinner" "$RESET" "$pct" \
        "$( repeat_char "$BAR_FILLER" $fill )" \
        "$( repeat_char "$BAR_EMPTY" $empty )" \
        "$ETA"

}

# Finalize progress bar / set to 100%
pg_finish () {
    LAST_DRAW_NS=0
    pg_update $TOTAL_ITEMS; echo
}
