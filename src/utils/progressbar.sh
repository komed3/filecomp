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
_LEN=$(( COLS - 22 ))

# Status vars
START_TIME=0
TOTAL=0
SPINNER_INDEX=0

# Initialize the progress bar
# Set start time, total items to count and reset spinner index
progressbar_init () {

    START_TIME=$( date +%s )
    TOTAL=$1
    SPINNER_INDEX=0

    progressbar_update 0

}

# Update (draw) progress bar
# Will automatically calculate ETA, progress and bar
progressbar_update () {



}

# Finalize progress bar / set to 100%
progressbar_finish () {

    progressbar_update $TOTAL
    echo

}

# Hide the progress bar
progressbar_clear () {
    tput cup $_ROW 0; tput el
}
