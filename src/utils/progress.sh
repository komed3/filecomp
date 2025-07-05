#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/ui.sh"

# Progress bar config
DRAW_INTERVAL_NS=50000000
SPINNER=( "⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏" )
BAR_ROW=$(( $ROWS - 5 ))
BAR_LEN=$(( $WIDTH - 22 ))
BAR_FILLER="#"
BAR_EMPTY=" "

# Status vars
SPINNER_INDEX=0
TOTAL_ITEMS=0
ETA="--:--:--"
BAR_START_TIME=0
BAR_LAST_DRAWN=0

# Initialize the progress bar
# Set start time, total items to count and reset spinner index
progress_init () {

    SPINNER_INDEX=0
    TOTAL_ITEMS=$1
    ETA="--:--:--"

    BAR_START_TIME=$( date +%s )
    BAR_LAST_DRAWN=0

    progress_update 0

}

# Update (draw) progress bar
# Will automatically calculate ETA, progress and bar
progress_update () {



}

# Hide / remove the progress bar
progress_clear () {
    set_line $BAR_ROW
}

# Finalize progress bar / set to 100%
progress_finish () {
    BAR_LAST_DRAWN=0
    progress_update $TOTAL_ITEMS
}
