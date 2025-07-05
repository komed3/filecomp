#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/ui.sh"

SPID=0

# Function to start a spinner
# Arguments:
#   $1: line number to display the spinner
#   $2: message to display
#   $3: initial sleep time (default 0.25 seconds)
#   $4: color for the spinner (default YELLOW)
#   $5: sleep time between spinner updates (default 0.1 seconds)
# Returns:
#   SPID: Process ID of the spinner
start_spinner () {

    (

        sleep ${3:-0.25}

        if ! kill -0 "$$" 2>/dev/null; then exit; fi

        local spin='-\|/' i=0

        while :; do
            set_line $1
            printf "%s%s  %s%s" "${4:-$YELLOW}" "$2 …" "${spin:i++%4:1}" "$RESET"
            sleep ${5:-0.1}
        done

    ) & SPID=$!

}

# Function to stop the spinner from the given Process ID
stop_spinner () {

    kill "$1" 2>/dev/null
    wait "$1" 2>/dev/null

}
