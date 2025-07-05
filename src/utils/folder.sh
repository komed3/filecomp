#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/ui.sh"
source "$SCRIPT_DIR/utils/ctrl.sh"

# Set display range
PATH_LINE=$START
PG_START=6
PG_END=$END
PG_MAX=$(( $ROWS - 12 ))

select_folder () {

    # Set up folder selection
    local current_path="$1"
    local entries

    local page=0 prev_page=-1
    local pointer=0 prev=-1

    # Print actions
    print_actions "UP/DN::Navigate" "LT/RT::Change directory" "PGUP/PGDN::Pages"

    # Clear the content
    clear_content

    # The main loop
    # Show the current directory
    while true; do

        # Jump to content
        jump_content

        # Read contents of the folder (directories only, with access check)
        mapfile -t entries < <( find "$current_path" -mindepth 1 -maxdepth 1 -type d -readable -exec test -x {} \; -print | sort )

        local total=${#entries[@]}
        local pages=$(( ( $total + $PG_MAX - 1 ) / $PG_MAX ))
        (( pages == 0 )) && pages=1

        # Pointer bounds check
        (( pointer < 0 )) && pointer=0
        (( pointer >= total )) && pointer=$(( $total > 0 ? $total - 1 : 0 ))

        # Calculate current page and offset
        page=$(( $pointer / $PG_MAX ))
        local offset=$(( $page * $PG_MAX ))

        # Print the current path with page info
        set_line $PATH_LINE
        printf "Path: %s%s%s   page %d of %d" \
            "$YELLOW" "$current_path" "$RESET" \
            "$(( $page + 1 ))" "$pages"

        # If no entries found
        if (( $total == 0 )); then

            set_line $PG_START
            printf "%s(No accessible subdirectories)%s" "$RED" "$RESET"

            for (( i=1; i < PG_MAX; i++ )); do
                set_line $(( $PG_START + $i ))
            done

        else

            # Page break or initial display
            if (( page != prev_page )); then

                for (( i=0; i < PG_MAX; i++ )); do

                    local idx=$(( $offset + $i ))
                    set_line $(( $PG_START + $i ))

                    if (( idx < total )); then

                        local name="$( basename "${entries[$idx]}" )" hl=""

                        if (( idx == pointer )); then hl="$REVID"; fi

                        printf "%s%s%s" "$hl" "$name" "$RESET"

                    fi

                done

            # Update only two lines (same page)
            elif (( pointer != prev )); then

                local old_line=$(( $PG_START + ( $prev % $PG_MAX ) ))
                local new_line=$(( $PG_START + ( $pointer % $PG_MAX ) ))

                if (( prev >= 0 && prev < total )); then
                    set_line $old_line
                    printf "%s" "$( basename "${entries[$prev]}" )"
                fi

                set_line $new_line
                printf "%s%s%s" "$REVID" "$( basename "${entries[$pointer]}" )" "$RESET"

            fi

        fi

        # Store last pointer pos. and page
        prev=$pointer
        prev_page=$page

    done

}