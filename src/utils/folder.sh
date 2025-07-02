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

source ./src/utils/key.sh
source ./src/utils/colors.sh
source ./src/utils/tui.sh

select_folder () {

    # Set up folder selection
    local title="$1"
    local current=$(( START + 1 ))
    local begin=$(( START + 3 ))
    local visible=$(( END - begin ))
    local current_path="$2"
    local entries

    local page=0
    local last_page=-1
    local pointer=0
    local last_pointer=-1
    local key

    # Clear previous content and print title
    clear_content; print_title "$title"

    # Print options / menu actions
    print_actions "[⇕] Navigate" "[⇔] Change directory" "[↵] Confirm" 2 "[Q] Quit"

    # The main loop
    while true; do

        # Jump to content
        jump_content

        # Read contents of the folder (directories only, with access check)
        mapfile -t entries < <(find "$current_path" -mindepth 1 -maxdepth 1 -type d -readable -exec test -x {} \; -print | sort)

        local total=${#entries[@]}
        local pages=$(( ( total + visible - 1 ) / visible ))

        # Pointer bounds check
        (( pointer < 0 )) && pointer=0
        (( pointer >= total )) && pointer=$(( total > 0 ? total - 1 : 0 ))

        page=$(( pointer / visible ))
        local offset=$(( page * visible ))

        # Print the current path with page info
        set_line $current
        printf "%sPath: %s%s%s [%d/%d]" \
            "$PRFX" "${YELLOW}" "$current_path" "${RESET}" \
            "$(( page + 1 ))" "$pages"

        # If no entries found
        if (( total == 0 )); then

            set_line $begin
            printf "%s%s(No accessible subdirectories)" "$PRFX" "${RED}"
            reset_color

            for (( i=1; i < visible; i++ )); do
                set_line $(( begin + i ))
            done

        else

            # Page break or initial display
            if (( page != last_page )); then

                for (( i=0; i < visible; i++ )); do

                    local index=$(( offset + i ))
                    set_line $(( begin + i ))

                    if (( index < total )); then

                        local name="$( basename "${entries[$index]}" )"

                        hl=""

                        if (( index == pointer )); then hl="${REV}"; fi

                        printf "%s%s%s" "$PRFX" "$hl" "$name"
                        reset_color

                    fi

                done

            # Update only two lines (same page)
            elif (( pointer != last_pointer )); then

                local old_line=$(( begin + ( last_pointer % visible ) ))
                local new_line=$(( begin + ( pointer % visible ) ))

                if (( last_pointer >= 0 && last_pointer < total )); then
                    set_line $old_line
                    printf "%s%s" "$PRFX" "$( basename "${entries[$last_pointer]}" )"
                fi

                set_line $new_line
                printf "%s%s%s" "$PRFX" "${REV}" "$( basename "${entries[$pointer]}" )"
                reset_color

            fi

        fi

        last_pointer=$pointer
        last_page=$page

        # Read key input (with escape for arrow keys)
        key=$( read_key )

        # Parse key input
        case "$key" in

            # Navigate upwards
            "arrow_up")
                if (( pointer > 0 )); then (( pointer-- ));
                else tput bel; fi
                ;;

            # Navigate down
            "arrow_down")
                if (( pointer < total - 1 )); then (( pointer++ ));
                else tput bel; fi
                ;;

            # Go to prev page
            "page_up")
                if (( page > 0 )); then pointer=$(( ( page - 1 ) * visible ));
                else tput bel; fi
                ;;

            # Go to next page
            "page_down")
                if (( page + 1 < pages )); then pointer=$(( ( page + 1 ) * visible ))
                else pointer=$(( total - 1 )); tput bel; fi
                ;;

            # Go deeper
            "arrow_right")
                if (( total > 0 )); then
                    current_path="${entries[$pointer]}"
                    pointer=0; last_page=-1; last_pointer=-1
                else tput bel; fi
                ;;

            # Come back a level
            "arrow_left")
                if [[ "$current_path" != "/" ]]; then
                    current_path="$( dirname "$current_path" )"
                    pointer=0; last_page=-1; last_pointer=-1
                else tput bel; fi
                ;;

            # Enter: get back the current (selected) directory
            # If within deepest directory, return current one
            "enter")
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
