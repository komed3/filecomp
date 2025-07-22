#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/ui.sh"

# Internal buffer
LOG=()
LOG_TYPE=()
LOG_SPINNER_PID=()
LOG_LAST=$START

update_log () {

    LOG+=( "$1" )
    LOG_TYPE+=( "${2:-"text"}" )
    LOG_SPINNER_PID+=( "" )

    local idx=$(( ${#LOG[@]} - 1 ))
    local line=$(( $START + $idx ))

    print_log_line "$line" "${LOG[$idx]}"

    LOG_LAST=$line

}

print_log_line () {

    local line="$1"
    local msg="$2"

    if (( ${#msg} > WIDTH )); then
        local half=$(( ( $WIDTH - 8 ) / 2 ))
        msg="${msg:0:$half}…${msg: -$half}"
    fi

    set_line "$line"; printf "%s" "$msg"

}

log_spinner_start () {

    local msg="$1"

    update_log "$msg" "spinner"
    start_spinner $LOG_LAST "$msg"

    LOG_SPINNER_PID[$LOG_LAST]="$SPID"

}

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

clear_log () {

    for pid in "${LOG_SPINNER_PID[@]}"; do
        [[ -n "$pid" ]] && kill "$pid" 2>/dev/null
    done

    LOG=()
    LOG_TYPE=()
    LOG_SPINNER_PID=()

    for (( i=START; i <= END; i++ )); do set_line $i; done

}
