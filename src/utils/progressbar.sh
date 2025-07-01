#!/bin/bash

# --------------------------------------------------------------------------------
# src/utils/progress.sh
# Progress bar
#
# Progress bar with spinner, percentage display, and estimated time of arrival
# (ETA). It displays in full color with a Braille spinner and a filled bar.
# --------------------------------------------------------------------------------

source ./src/utils/tui.sh

# Progress bar config
SPINNER_CHARS=( "⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏" )
BAR_FILLER="█"
BAR_EMPTY=" "
_ROW=$(( ROWS - 5 ))
_LEN=$(( COLS - 22 - ( LGAP * 2 ) ))

# Status vars
START_TIME=0
SPINNER_INDEX=0
TOTAL_ITEMS=0

# Initialize the progress bar
# Set start time, total items to count and reset spinner index
progressbar_init () {

    START_TIME=$( date +%s )
    SPINNER_INDEX=0
    TOTAL_ITEMS=$1

    progressbar_update 0

}

# Update (draw) progress bar
# Will automatically calculate ETA, progress and bar
progressbar_update () {

    # Calculate the current progress
    local now=$( date +%s )
    local elapsed=$(( now - START_TIME ))
    local cur=$1

    # Get the current spinner character
    local spinner=${SPINNER_CHARS[SPINNER_INDEX]}

    # Update the spinner index
    # Wrap around if it exceeds the length of the spinner array
    SPINNER_INDEX=$(( ( SPINNER_INDEX + 1 ) % ${#SPINNER_CHARS[@]} ))

    # Calculate the percentage and remaining time
    local pct=$(( cur * 100 / TOTAL_ITEMS ))
    local clk="--:--:--"

    if (( cur > 0 )); then
        local eta=$(( elapsed * ( TOTAL_ITEMS - cur ) / cur ))
        clk=$( date -u -d "@$eta" +%H:%M:%S )
    fi

    # Calculate progress bar fill and empty parts
    local fill=$(( pct * _LEN / 100 ))
    local empty=$(( _LEN - fill ))

    # Output the formatted progress bar
    tput cup $_ROW 0
    printf "%s%s %3d%% [%s%s] ETA %s" \
        "$PRFX" "$spinner" "$pct" \
        "$(printf "%${fill}s" | tr ' ' "$BAR_FILLER")" \
        "$(printf "%${empty}s" | tr ' ' "$BAR_EMPTY")" \
        "$clk"

}

# Finalize progress bar / set to 100%
progressbar_finish () {
    progressbar_update $TOTAL; echo
}

# Hide the progress bar
progressbar_clear () {
    tput cup $_ROW 0; tput el
}
