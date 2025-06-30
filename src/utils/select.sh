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

    # Change terminal output (hide cursor, clean up on abort)
    tput civis
    trap "tput cnorm; clear; exit" SIGINT SIGTERM

    # Main loop
    while true; do

        # Print the select menu title
        clear; tput bold; echo "$title"; tput sgr0; echo

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

        # Print options / menu actions
        echo; tput bold; echo "[↑/↓] Move  [␣] Toggle  [↵] Confirm  [Q] Quit"; tput sgr0; echo

        # Read key input (with escape for arrow keys)
        IFS= read -rsn1 key

        if [[ $key == $'\x1b' ]]; then
            read -rsn2 rest
            key+="$rest"
        fi

        # Parse key input
        case "$key" in

            # Navigate upwards
            $'\x1b[A')
                (( pointer = ( pointer - 1 + count ) % count ))
                ;;

            # Navigate down
            $'\x1b[B')
                (( pointer = ( pointer + 1 ) % count ))
                ;;

            # Toggle selection
            " ")
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
            "")
                if (( require_one == 1 )); then
                    local any=0
                    for v in "${selected[@]}"; do (( v == 1 )) && any=1; done
                    (( any == 1 )) || { tput bel; continue; }
                fi
                break
                ;;

            # Quit program
            [qQ])
                tput cnorm; clear; exit 1
                ;;

        esac

    done

    # reset terminal
    tput cnorm

    # Write result to array
    result=()

    for i in "${!selected[@]}"; do
        (( selected[i] == 1 )) && result+=("$i")
    done

}