#!/bin/bash

# --------------------------------------------------------------------------------
# src/utils/folder.sh
# Interactive Folder Selection
#
# Directory navigator with arrow key control, similar to Midnight Commander:
# -> up/down = navigation
# -> right = in, left = back
# -> Enter selects folder
# --------------------------------------------------------------------------------

source ./src/utils/colors.sh
source ./src/utils/tui.sh

select_folder () {

    # Set up folder selection
    local title="$1"
    local current=$(( START + 1 ))
    local begin=$(( START + 3 ))
    local current_path="$2"
    local entries

    local pointer=0
    local key

    # Clear previous content and print title
    clear_content; print_title "$title"

    # Print options / menu actions
    print_actions "[⇕] Navigate" "[⇔] Change directory" "[↵] Confirm" 2 "[Q] Quit"

    # The main loop
    # Show list of directories
    while true; do

        # Jump to content
        jump_content

        # Print the current path
        tput cup $current 0; tput el
        printf "%sPath: %s%s" "$PRFX" "${YELLOW}" "$current_path"
        reset_color

        # Read contents of the folder (directories only)
        mapfile -t entries < <(find "$current_path" -mindepth 1 -maxdepth 1 -type d | sort)
        local visible_count=$(( END - begin ))

        # Calculate start position of the display (for scroll effect)
        local offset=0
        (( pointer >= visible_count )) && offset=$(( pointer - visible_count + 1 ))

        # Show visible entries
        for (( i=0; i < visible_count; i++ )); do

            local index=$(( i + offset ))
            local line=$(( begin + i ))

            tput cup $line 0; tput el

            [[ $index -ge ${#entries[@]} ]] && break

            local name="$( basename "${entries[$index]}" )"

            hl=""

            if (( index == pointer )); then hl="${REV}"; fi

            printf "%s%s%s" "$PRFX" "$hl" "$name"
            reset_color

        done

        # Delete old lines surplus to demand
        for (( i=${#entries[@]} - offset; i < visible_count; i++ )); do
            local line=$(( begin + i ))
            tput cup $line 0; tput el
        done

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
                (( pointer > 0 )) && (( pointer-- ))
                ;;

            # Navigate down
            $'\x1b[B')
                (( pointer < ${#entries[@]} - 1 )) && (( pointer++ ))
                ;;

            # Go deeper
            $'\x1b[C')
                current_path="${entries[$pointer]}"
                pointer=0
                ;;

            # Come back a level
            $'\x1b[D')
                current_path="$( dirname "$current_path" )"
                pointer=0
                ;;

            # Enter: get back the current (selected) directory
            # If within deepest directory, return current one
            "")
                result="${entries[$pointer]:-$current_path}"
                break
                ;;

            # Quit program
            [qQ])
                quit
                ;;

        esac

    done

}