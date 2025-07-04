#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/ui.sh"
source "$SCRIPT_DIR/utils/ctrl.sh"

SELECT_NULL=( 1 )

select_menu () {

    # Proceed inputs
    local multi_flag="$1"               # 0 = Radio (single), 1 = Checkbox (multi)
    local require_one="$2"              # 1 = at least one selection required
    local allow_none="$3"               # 1 = no choice allowed, 0 = at least one for radio
    local opts_name="$4"                # Array name of the options
    local init_name="${5:-SELECT_NULL}" # Array name of initial states

    # Set refs to the given arrays
    local -n opts_ref="${opts_name}"
    local -n init_ref="${init_name}"
    local -a selected                   # Selected indices

    # Define some variables to contol inputs
    local count=${#opts_ref[@]}         # Number of options
    local pointer=0                     # Current cursor position

    # Set initial states (default 0)
    for (( i=0; i < count; i++ )); do
        selected[i]=${init_ref[$i]:-0}
    done

    clear_content

    # List all options
    for i in "${!opts_ref[@]}"; do

        hl=""; mark=" "

        # Highlight current line
        if (( i == pointer )); then hl="$REVID"; fi

        # Mark "x" on selected option
        if (( selected[$i] == 1 )); then mark="x"; fi

        # Print the line
        printf "%s%s[%s] %s%s\n" "$PRFX" "$hl" "$mark" "${opts_ref[$i]}" "$RESET"

    done

    await_to_proceed

}