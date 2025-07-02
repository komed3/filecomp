#!/bin/bash

# --------------------------------------------------------------------------------
# src/utils/select.sh
# Interactive Terminal Menu (radio & checkbox)
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

source "$SCRIPT_DIR/utils/key.sh"
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/tui.sh"

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

    # Clear previous content
    clear_content

    # Print options / menu actions
    print_actions "[UP/DN] Move" "[SPACE] Toggle" "[ENTER] OK" 2 "[Q] Quit"

    # The main loop
    # Show options list and proceed user inputs
    while true; do

        # Jump to content
        jump_content

        # Print the menu title
        print_title "$title"

        # List all options
        for i in "${!opts_ref[@]}"; do

            hl=""; mark=" "

            # Highlight current line
            if (( i == pointer )); then hl="${REV}"; fi

            # Mark "x" on selected option
            if (( selected[i] == 1 )); then mark="x"; fi

            # Print the line
            printf "%s%s[%s] %s\n" "$PRFX" "$hl" "$mark" "${opts_ref[i]}"
            reset_color

        done

        # Read key input (with escape for arrow keys)
        key=$( read_key )

        # Parse key input
        case "$key" in

            # Navigate upwards
            "arrow_up")
                (( pointer = ( pointer - 1 + count ) % count ))
                ;;

            # Navigate down
            "arrow_down")
                (( pointer = ( pointer + 1 ) % count ))
                ;;

            # Toggle selection
            "space")
                if (( multi_flag == 0 )); then
                    # Radio: deselect all, then activate the current one
                    for (( j=0; j < count; j++ )); do selected[j]=0; done
                    selected[pointer]=1
                else
                    # Checkbox: only deselect if allowed
                    if (( selected[pointer] == 1 )); then
                        (( allow_none == 1 )) && selected[pointer]=0
                    else
                        selected[pointer]=1
                    fi
                fi
                ;;

            # Enter: only continue if selection is valid
            # If input is required, beep on empty
            "enter")
                if (( require_one == 1 )); then
                    local any=0
                    for v in "${selected[@]}"; do (( v == 1 )) && any=1; done
                    (( any == 1 )) || { tput bel; continue; }
                fi
                break
                ;;

            # Quit program
            [qQ])
                quit
                ;;

        esac

    done

    # Write result to array
    result=()

    for i in "${!selected[@]}"; do
        (( selected[i] == 1 )) && result+=("$i")
    done

}
