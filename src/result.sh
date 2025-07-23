#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/ui.sh"
source "$SCRIPT_DIR/utils/ctrl.sh"

# Delete all results and files
delete_results () {

    # Print the title
    print_title "DELETE RESULTS"

    # Clear the screen
    print_actions; clear_content

    printf "%s%sNow all results and files will be deleted!%s\n" "$PRFX" "$RED" "$RESET"
    printf "%s%sAfterwards the program will quit.%s\n" "$PRFX" "$RED" "$RESET"

    # Remove the hash database and log file
    rm -f "$HASH_DB" "$LOG_FILE"

    # Remove the copy directory if it exists
    [[ -n "$COPY_DIR" && -d "$COPY_DIR" ]] && rm -rf "$COPY_DIR"

    # Quit the program
    sleep 5; quit

}

# Delete the hash database if needed
delete_db () {
    if (( DB_DELETE == 1 )); then rm "$HASH_DB"; fi
}

# Print the result screen and list all unique files
print_result () {

    local unique=$( wc -l < "$TMP_FILE" )
    local -a unique_files
    local tab=0 prev=-1
    local files_per_page=$(( $HEIGHT - 2 ))
    local max=$(( ( $unique / $files_per_page ) + 2 ))

    # Load all unique files from TMP_FILE
    if [[ -f "$TMP_FILE" ]]; then
        mapfile -t unique_files < "$TMP_FILE"
    fi

    # Print actions
    print_actions "TAB::Page" "BACK::Delete Results" "Q::Quit"

    # Print the title
    print_title "FILECOMP RESULTS"

    while true; do

        # Render only if the tab has changed
        if (( prev != tab )); then

            # Clear the screen
            clear_content

            # Info page
            if (( tab == 0 )); then

                local info_label=(
                    "Base directory" "Compare with  "
                    "Hash database " "Unique files  "
                )

                local info_value=(
                    "$BASE_DIR" "$COMP_DIR"
                    "$( stat -c %s "$HASH_DB" 2>/dev/null || echo 0 ) bytes"
                    "${unique} files"
                )

                # Print list of info
                for i in "${!info_label[@]}"; do

                    printf "%s%s  :  %s%s%s\n" \
                        "$PRFX" "${info_label[$i]}" \
                        "$CYAN$BOLD" "${info_value[$i]:-"N/A"}" \
                        "$RESET"

                done

                printf "\n%sUse %s[Tab]%s to view all unique files." "$PRFX" "$BOLD" "$RESET"
                printf "\n%sDelete all files and results by pressing %s[Backspace]%s." "$PRFX" "$BOLD" "$RESET"
                printf "\n%sExit the program with %s[Q]%s." "$PRFX" "$BOLD" "$RESET"

            # File page
            else

                local start_idx=$(( ( $tab - 1 ) * $files_per_page ))
                local end_idx=$(( $start_idx + $files_per_page - 1 ))
                (( end_idx >= unique )) && end_idx=$(( $unique - 1 ))

                set_line $START
                printf "Unique files   %s[%d/%d]%s\n\n" "$REVID" "$tab" "$(( $max - 1 ))" "$RESET"

                for (( i=start_idx; i <= end_idx && i < unique; i++ )); do
                    printf "%s%s\n" "$PRFX" "${unique_files[$i]}"
                done

            fi

            # Set previous tab to current
            prev=$tab

        fi

        # Read key input
        read_key

        # Check for commands
        case "$KEY" in
            "tab" )   tab=$(( ( $tab + 1 ) % $max )) ;;
            "back" )  delete_results ;;
            "quit" )  delete_db; quit ;;
        esac

    done

}
