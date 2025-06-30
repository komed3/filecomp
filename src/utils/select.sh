#!/bin/bash

# --------------------------------------------------------------------------------
# src/utils/select.sh
# Interactive terminal menu (radio & checkbox)
#
# Function: select_menu
# Parameters:
# $1 - Title (String)
# $2 - Type: 'multi=0' (radio) or 'multi=1' (checklist)
# $3 - require_one: '1' = at least one selection required, '0' = optional
# $4 - allow_none: '1' = deselection to zero allowed, '0' = at least one selection for radio
# $5 - Array name of the options (without @)
# $6 - Array name of initial states (without @)
# Return:
# Array 'result' contains the selected indices
# --------------------------------------------------------------------------------

select_menu () {

    # Proceed inputs
    local title="$1"
    local multi_flag="$2"        # 0 = Radio (single), 1 = Checkbox (multi)
    local require_one="$3"       # 1 = at least one selection required
    local allow_none="$4"        # 1 = no choice allowed, 0 = at least one for radio
    local opts_name="$5"         # Array name of the options
    local init_name="$6"         # Array name of initial states

    # Set refs to the given arrays
    local -n opts_ref="${opts_name}"
    local -n init_ref="${init_name}"
    local -a selected            # Selected indices

    # Define some variables to contol inputs
    local count=${#opts_ref[@]}  # Number of options
    local pointer=0              # Current cursor position
    local key                    # Buffer for key input

    # Set initial states (default 0)
    for (( i=0; i < count; i++ )); do
        selected[i]=${init_ref[i]:-0}
    done

    # Main loop
    while true; do

        clear
        echo "$title"
        echo

        # List all options
        for i in "${!opts_ref[@]}"; do

            # Highlight cursor on current line
            if (( i == pointer )); then
                cursor="$(tput setaf 3) > $(tput sgr0)"
            else
                cursor="   "
            fi

            # Mark with green "x" or empty depending on selection status
            if (( selected[i] == 1 )); then
                mark="$(tput setaf 2)x$(tput sgr0)"
            else
                mark=" "
            fi

            # Print the line
            printf "%s[%s] %s\n" "$cursor" "$mark" "${opts_ref[i]}"

        done

    done

}