#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/ui.sh"
source "$SCRIPT_DIR/utils/ctrl.sh"

# Default state to select first option
SELECT_NULL=( 1 )

# Function to display a selection menu
# Arguments:
#   $1: multi_flag (0 = Radio, 1 = Checkbox)
#   $2: require_one (1 = at least one selection required)
#   $3: allow_none (1 = no choice allowed, 0 = at least one for radio)
#   $4: opts_name (Array name of the options)
#   $5: init_name (Array name of initial states, default is SELECT_NULL)
# Returns:
#   result: Array of selected indices
select_menu () {

    # Proceed inputs
    local multi_flag="$1"
    local require_one="$2"
    local allow_none="$3"
    local opts_name="$4"
    local init_name="${5:-SELECT_NULL}"

    # Set refs to the given arrays
    local -n opts_ref="${opts_name}"
    local -n init_ref="${init_name}"
    local -a selected

    # Define some variables to contol inputs
    local count=${#opts_ref[@]}
    local pointer=0

    # The result array
    result=()

    # Set initial states (default 0)
    for (( i=0; i < count; i++ )); do
        selected[$i]=${init_ref[$i]:-0}
    done

    # Print actions
    print_actions "UP/DN::Navigate" "SPACE::Select"

    # Clear the content
    clear_content

    # The main loop
    # Show options list and proceed user inputs
    while true; do

        # Jump to content
        jump_content

        # List all options
        for i in "${!opts_ref[@]}"; do

            local hl="" mark=" "

            # Highlight current line
            if (( i == pointer )); then hl="$REVID"; fi

            # Mark "x" on selected option
            if (( selected[$i] == 1 )); then mark="x"; fi

            # Print the option
            printf "%s%s[%s] %s%s\n" "$PRFX" "$hl" "$mark" "${opts_ref[$i]}" "$RESET"

        done

        # Read key input
        read_key

        # Check for commands
        case "$KEY" in

            # Navigate upwards
            "up" ) (( pointer = ( pointer - 1 + count ) % count )) ;;

            # Navigate down
            "down" ) (( pointer = ( pointer + 1 ) % count )) ;;

            # Toggle selection
            "space" )
                if (( multi_flag == 0 )); then
                    # Radio: deselect all, then activate the current one
                    for (( j=0; j < count; j++ )); do selected[$j]=0; done
                    selected[$pointer]=1;
                else
                    # Checkbox: only deselect if allowed
                    if (( selected[$pointer] == 1 )); then
                        (( allow_none == 1 )) && selected[$pointer]=0
                    else
                        selected[$pointer]=1
                    fi
                fi ;;

            # Enter: only continue if selection is valid
            # If input is required, beep on empty
            "enter" )
                if (( require_one == 1 )); then
                    local any=0
                    for v in "${selected[@]}"; do (( v == 1 )) && any=1; done
                    (( any == 1 )) || { tput bel; continue; }
                fi
                break ;;

            # Quit the program
            [qQ] ) quit ;;

        esac

    done

    # Write result to array
    for i in "${!selected[@]}"; do
        (( selected[$i] == 1 )) && result+=( "$i" )
    done

}
