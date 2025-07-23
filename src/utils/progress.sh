#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/ui.sh"

# Progress bar config
BAR_DRAW_INTERVAL=50000000
SPINNER_CHARS=( "⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏" )
BAR_ROW=$(( $ROWS - 5 ))
BAR_LEN=$(( $WIDTH - 26 ))
BAR_FILLER="■"
BAR_EMPTY=" "

# Status vars
SPINNER_INDEX=0
TOTAL_ITEMS=0
PROCESSED_ITEMS=0
ETA="--:--:--"
BAR_START_TIME=0
BAR_LAST_DRAWN=0

# Initialize the progress bar
# Set start time, total items to count and reset spinner index
progress_init () {

    SPINNER_INDEX=0
    TOTAL_ITEMS=$1
    PROCESSED_ITEMS=0
    ETA="--:--:--"

    BAR_START_TIME=$( date +%s )
    BAR_LAST_DRAWN=0

    progress_update 0

}

# Update (draw) progress bar
# Will automatically calculate ETA, progress and bar
progress_update () {

    local ts=$( date +%s%N )
    local delta=$(( $ts - $BAR_LAST_DRAWN ))

    if (( delta < BAR_DRAW_INTERVAL )); then return; fi

    PROCESSED_ITEMS=$1
    BAR_LAST_DRAWN=$ts

    # Calculate the current progress
    local now=$( date +%s )
    local elapsed=$(( $now - $BAR_START_TIME ))

    # Get the current spinner character
    local spinner=${SPINNER_CHARS[$SPINNER_INDEX]}

    # Update the spinner index
    # Wrap around if it exceeds the length of the spinner array
    SPINNER_INDEX=$(( ( $SPINNER_INDEX + 1 ) % ${#SPINNER_CHARS[@]} ))

    # Calculate the percentage and remaining time
    local pct=$(( $PROCESSED_ITEMS * 100 / $TOTAL_ITEMS ))

    if (( pct == 100 )); then spinner="✔"; fi;

    if (( SPINNER_INDEX % 50 == 0 && PROCESSED_ITEMS > 0 )); then
        local eta=$(( $elapsed * ( $TOTAL_ITEMS - $PROCESSED_ITEMS ) / $PROCESSED_ITEMS ))
        ETA=$( date -u -d "@$eta" +%H:%M:%S )
    fi

    # Calculate progress bar fill and empty parts
    local fill=$(( $pct * $BAR_LEN / 100 ))
    local empty=$(( $BAR_LEN - $fill ))

    # Clear the progress bar
    progress_clear

    # Output the formatted progress bar
    printf "%s%s%s  %3d%% | %s%s%s%s  | ETA %s" \
        "$CYAN" "$spinner" "$RESET" "$pct" "$CYAN" \
        "$( repeat_char "$BAR_FILLER" $fill )" "$RESET" \
        "$( repeat_char "$BAR_EMPTY" $empty )" "$ETA"

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

# Returns the elapsed time since progress_init as a formatted string
progress_duration () {

    # Get the current time and calculate elapsed time
    local now=$( date +%s )
    local elapsed=$(( $now - $BAR_START_TIME ))
    (( elapsed == 0 )) && elapsed=1

    # Format the elapsed time into hours, minutes, and seconds
    local -i h=$(( $elapsed / 3600 ))
    local -i m=$(( ( $elapsed % 3600 ) / 60 ))
    local -i s=$(( $elapsed % 60 ))

    # Create a formatted string for the elapsed time
    # Only include non-zero values
    local out=""
    (( h > 0 )) && out+="${h}h "
    (( m > 0 )) && out+="${m}m "
    out+="${s}s"

    # Return the formatted elapsed time
    echo "$out"

}

# Returns the current processing rate in items per second
progress_rate () {

    # Get the current time and calculate elapsed time
    local now=$( date +%s )
    local elapsed=$(( $now - $BAR_START_TIME ))
    (( elapsed == 0 )) && elapsed=1

    # Calculate and return the processing rate
    echo $(( $PROCESSED_ITEMS / $elapsed ))

}
