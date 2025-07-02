#!/bin/bash

# --------------------------------------------------------------------------------
# src/utils/log.sh
# Log Output (Live Log View)
#
# Provides a scrollable, color-coded log window in the TUI. New lines are
# added at the bottom. If maximum lines reached, oldest lines are removed to
# simulate scroll behavior.
# --------------------------------------------------------------------------------

source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/tui.sh"

# Internal buffer
LOG_LINES=()

# Set display range
LOG_START=$(( START + 2 ))
LOG_END=$(( END ))
LOG_MAX=$(( LOG_END - LOG_START ))

# Clear the log view entirely
clear_log () {
    for (( i=LOG_START; i <= LOG_END; i++ )); do set_line $i; done
    LOG_LINES=()
}

# Add a new line to the live log
# $1 - Line content
# $2 - Optional color index
update_log () {

    local text="$1"
    local color=$2

    # Append to buffer
    LOG_LINES+=( "$text" )

    # Remove oldest if over capacity
    if (( ${#LOG_LINES[@]} >= LOG_MAX )); then
        LOG_LINES=( "${LOG_LINES[@]:1}" )
    fi

    # Draw updated log
    for (( i=0; i < ${#LOG_LINES[@]}; i++ )); do

        local line=$(( LOG_START + i ))
        local msg="${LOG_LINES[$i]}"

        # Truncate overly long lines (middle ellipsis)
        if (( ${#msg} > LENGTH )); then
            local half=$(( ( LENGTH - 1 ) / 2 ))
            msg="${msg:0:$half}…${msg: -$half}"
        fi

        set_line $line

        # Print the line
        printf "%s%s" "$PRFX" "$( color_output "$msg" $color )"

    done

}
