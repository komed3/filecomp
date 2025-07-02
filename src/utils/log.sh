#!/bin/bash

# --------------------------------------------------------------------------------
# src/utils/log.sh
# Log Output (Live Log View)
#
# Provides a scrollable log window in the TUI.
#
# New lines are added at the bottom. If maximum lines reached, oldest lines
# are removed to simulate scroll behavior.
# --------------------------------------------------------------------------------

source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/tui.sh"

# Internal buffer
LOG_LINES=()

# Set display range
LOG_START=$(( START + 2 ))
LOG_END=$(( END ))
LOG_MAX=$(( LOG_END - LOG_START + 1 ))

# Clear the log view entirely
clear_log () {
    for (( i=LOG_START; i <= LOG_END; i++ )); do set_line $i; done
    LOG_LINES=()
}

# Add a new line to the live log
update_log () {

    # Append to buffer
    LOG_LINES+=( "$1" )

    # Remove oldest if over capacity
    while (( ${#LOG_LINES[@]} > LOG_MAX )); do
        LOG_LINES=( "${LOG_LINES[@]:1}" )
    done

    # Draw updated log
    local i
    for (( i=0; i < ${#LOG_LINES[@]}; i++ )); do

        local line=$(( LOG_START + i ))
        local msg="${LOG_LINES[$i]}"

        # Truncate overly long lines (middle ellipsis)
        if (( ${#msg} > LENGTH )); then
            local half=$(( ( LENGTH - 1 ) / 2 ))
            msg="${msg:0:$half}…${msg: -$half}"
        fi

        # Print the line
        set_line $line; printf "%s%s" "$PRFX" "$msg"

    done

}
