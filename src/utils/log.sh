#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/ui.sh"

# Internal buffer
LOG=()
LOG_TYPE=()
LOG_SPINNER_PID=()
LOG_LAST=$START

# Update the log buffer with a new message
# Arguments:
#   $1: Message to log
#   $2: Type of log message (default "text")
#       "text" for normal messages
#       "spinner" for spinner messages
# This function appends the message to the log buffer and prints it on the screen.
# If the log buffer exceeds the terminal height, the oldest entries will be removed.
update_log () {

    LOG+=( "$1" )
    LOG_TYPE+=( "${2:-"text"}" )
    LOG_SPINNER_PID+=( "" )

    local idx=$(( ${#LOG[@]} - 1 ))
    local line=$(( $START + $idx ))

    print_log_line "$line" "${LOG[$idx]}"

    LOG_LAST=$line

}

# Internal: Print a log line with a message
# Arguments:
#   $1: Line number to print the log message on
#   $2: Message to print
# If the message is longer than the terminal width, it will be truncated with an ellipsis
# and centered.
print_log_line () {

    local line="$1"
    local msg="$2"

    if (( ${#msg} > WIDTH )); then
        local half=$(( ( $WIDTH - 8 ) / 2 ))
        msg="${msg:0:$half}…${msg: -$half}"
    fi

    set_line "$line"; printf "%s" "$msg"

}

# Start a spinner for the last log entry
# Arguments:
#   $1: Message to display in the spinner
log_spinner_start () {

    local msg="$1"

    update_log "$msg" "spinner"
    start_spinner $LOG_LAST "$msg"

    LOG_SPINNER_PID[$LOG_LAST]="$SPID"

}

# Stop the spinner for the given log index
# Arguments:
#   $1: Index of the log entry to stop the spinner for
log_spinner_stop () {

    local idx="$1"
    local pid="${LOG_SPINNER_PID[$idx]}"

    if [[ -n "$pid" ]]; then

        stop_spinner "$pid"

        LOG[$idx]="${LOG[$idx]} … DONE"
        LOG_TYPE[$idx]="text"
        LOG_SPINNER_PID[$idx]=""

        print_log_line $(( $START + $idx )) "${LOG[$idx]}"

    fi

}

# Clear the log view entirely
clear_log () {

    # Stop all active spinners
    for pid in "${LOG_SPINNER_PID[@]}"; do
        [[ -n "$pid" ]] && kill "$pid" 2>/dev/null
    done

    # Clear the log buffers
    LOG=()
    LOG_TYPE=()
    LOG_SPINNER_PID=()
    LOG_LAST=$START

    # Clear the log view
    for (( i=START; i <= END; i++ )); do set_line $i; done

}
