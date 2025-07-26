#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/ui.sh"

# Progress bar config
PROG_ROW=$(( $ROWS - 5 ))
PROG_INTERVAL=50000000
SPINNER_CHARS=( "⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏" )
SPINNER_POS=$LGAP
PCT_POS=$(( $LGAP + 3 ))
ETA_POS=$(( $LGAP + $WIDTH - 12 ))
BAR_POS=$(( $LGAP + 8 ))
BAR_LEN=$(( $WIDTH - 26 ))
BAR_FILLER="■"
BAR_EMPTY=" "

# Status vars
SPINNER_INDEX=0
PROG_TOTAL=0
PROG_PROCESSED=0
ETA="--:--:--"
PROG_START_TIME=0
PROG_LAST_DRAWN=0

# Internal: Track last drawn values for minimal redraw
LAST_PCT=-1
LAST_FILL=-1
LAST_EMPTY=-1
LAST_ETA=""

# Initialize the progress bar
# Set start time, total items to count and reset spinner index
progress_init () {

    SPINNER_INDEX=0
    PROG_TOTAL=$1
    PROG_PROCESSED=0
    ETA="--:--:--"

    PROG_START_TIME=$( date +%s )
    PROG_LAST_DRAWN=0

    LAST_PCT=-1
    LAST_FILL=-1
    LAST_EMPTY=-1
    LAST_ETA=""

    progress_update 0

}

# Update (draw) progress bar
# Will automatically calculate ETA, progress and bar
progress_update () {

    local ts=$( date +%s%N )
    local delta=$(( $ts - $PROG_LAST_DRAWN ))

    if (( delta < PROG_INTERVAL )); then return; fi

    PROG_PROCESSED=$1
    PROG_LAST_DRAWN=$ts

    # Calculate the current progress
    local now=$( date +%s )
    local elapsed=$(( $now - $PROG_START_TIME ))

    # Get the current spinner character
    local spinner=${SPINNER_CHARS[$SPINNER_INDEX]}

    # Update the spinner index
    # Wrap around if it exceeds the length of the spinner array
    SPINNER_INDEX=$(( ( $SPINNER_INDEX + 1 ) % ${#SPINNER_CHARS[@]} ))

    # Calculate the percentage and remaining time
    local pct=$(( $PROG_PROCESSED * 100 / $PROG_TOTAL ))

    if (( pct == 100 )); then spinner="✔"; fi;

    # Calculate ETA only every 50 spinner steps or at 100%
    if (( SPINNER_INDEX % 50 == 0 && PROG_PROCESSED > 0 )) || (( pct == 100 )); then
        local eta=$(( $elapsed * ( $PROG_TOTAL - $PROG_PROCESSED ) / ( $PROG_PROCESSED > 0 ? $PROG_PROCESSED : 1 ) ))
        ETA=$( date -u -d "@$eta" +%H:%M:%S )
    fi

    # Calculate progress bar fill and empty parts
    local fill=$(( $pct * $BAR_LEN / 100 ))
    local empty=$(( $BAR_LEN - $fill ))

    # Only redraw what changed (use tput cup for partial updates)

    # Spinner
    tput cup $PROG_ROW $SPINNER_POS
    printf "%s%s%s" "$CYAN" "$spinner" "$RESET"

    # Percent
    if (( pct != LAST_PCT )); then
        tput cup $PROG_ROW $PCT_POS
        printf "%3d%%" "$pct"
        LAST_PCT=$pct
    fi

    # Progress bar
    if (( fill != LAST_FILL || empty != LAST_EMPTY )); then
        tput cup $PROG_ROW $BAR_POS
        printf "| %s%s%s%s  |" \
            "$CYAN" "$( repeat_char "$BAR_FILLER" $fill )" \
            "$RESET" "$( repeat_char "$BAR_EMPTY" $empty )"
        LAST_FILL=$fill
        LAST_EMPTY=$empty
    fi

    # ETA
    if [[ "$ETA" != "$LAST_ETA" ]]; then
        tput cup $PROG_ROW $ETA_POS
        printf "ETA %s" "$ETA"
        LAST_ETA="$ETA"
    fi

}

# Hide / remove the progress bar
progress_clear () {
    set_line $PROG_ROW 0
}

# Finalize progress bar / set to 100%
progress_finish () {
    PROG_LAST_DRAWN=0
    progress_update $PROG_TOTAL
}

# Returns the elapsed time since progress_init as a formatted string
progress_duration () {

    # Get the current time and calculate elapsed time
    local now=$( date +%s )
    local elapsed=$(( $now - $PROG_START_TIME ))
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
    local elapsed=$(( $now - $PROG_START_TIME ))
    (( elapsed == 0 )) && elapsed=1

    # Calculate and return the processing rate
    echo $(( $PROG_PROCESSED / $elapsed ))

}
