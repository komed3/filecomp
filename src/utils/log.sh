#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/ui.sh"

# Internal buffer
LOG=()

# Update the log buffer with a new message
# Arguments:
#   $1: Message to log
# This function appends the message to the log buffer and prints it on the screen.
# If the log buffer exceeds the terminal height, the oldest entries will be removed.
update_log () {

    # Clear the screen if over capacity
    if (( ${#LOG[@]} >= HEIGHT )); then clear_log; fi

    # Add the new message to the log buffer
    LOG+=( "$1" )

    # Calculate log line number
    local idx=$(( ${#LOG[@]} - 1 ))
    local line=$(( $START + $idx ))

    # Print the new message
    print_log_line "$line" "${LOG[$idx]}"

}

# Internal: Print a log line with a message
# Arguments:
#   $1: Line number to print the log message on
#   $2: Message to print
# If the message is longer than the terminal width, it will be truncated with
# an ellipsis and centered.
print_log_line () {

    local line="$1"
    local msg="$2"

    if (( ${#msg} > WIDTH )); then
        local half=$(( ( $WIDTH - 8 ) / 2 ))
        msg="${msg:0:$half}…${msg: -$half}"
    fi

    set_line "$line"; printf "%s" "$msg"

}

# Clear the log view entirely
clear_log () {

    # Clear the log buffer
    LOG=()

    # Clear the log view
    for (( i=START; i <= END; i++ )); do set_line $i; done

}
