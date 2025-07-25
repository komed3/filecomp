#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/ui.sh"

# Last log line
LOG_LAST=$START

# Update the log view with a new message
# This will print the message on the next available line in the log view.
# If the log view is full, it will clear the screen and start from the top.
# Arguments:
#   $1: Message to log
update_log () {

    # Clear the screen if over capacity
    if (( LOG_LAST > HEIGHT )); then clear_log; fi

    # Increment last log line
    (( LOG_LAST++ ))

    # Print the new message
    print_log_line "$LOG_LAST" "$1"

}

# Update the log view with a new message
# This will print the message on the last line of the log view.
update_log_last () {
    print_log_line "$LOG_LAST" "$1"
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

    # Reset last log line
    LOG_LAST=$START

    # Clear the log view
    for (( i=START; i <= END; i++ )); do set_line $i; done

}
