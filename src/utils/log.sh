#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/ui.sh"

# Internal buffer
LOG=()

# Clear the log view entirely
clear_log () {
    for (( i=START; i <= END; i++ )); do set_line $i; done
    LOG=()
}

# Add a new line to the live log
update_log () {

    # Append to buffer
    LOG+=( "$1" );

    # Remove oldest if over capacity
    while (( ${#LOG[@]} > HEIGHT )); do
        LOG=( "${LOG[@]:1}" )
    done

    # Draw updated log
    local i
    for (( i=0; i < ${#LOG[@]}; i++ )); do

        local line=$(( $START + $i ))
        local msg="${LOG[$i]}"

        # Truncate overly long lines (middle ellipsis)
        if (( ${#msg} > WIDTH )); then
            local half=$(( ( $WIDTH - 1 ) / 2 ))
            msg="${msg:0:$half}…${msg: -$half}"
        fi

        # Print the line
        set_line $line; printf "%s" "$msg"

    done

}
