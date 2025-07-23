#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/ui.sh"
source "$SCRIPT_DIR/utils/ctrl.sh"

# Delete all results and files
delete_results () {

    # Clear the screen
    clear_content

    printf "%s%sNow all results and files will be deleted!%s\n" "$PRFX" "$RED" "$RESET"
    printf "%s%sAfterwards the program will quit.%s\n" "$PRFX" "$RED" "$RESET"

    # Remove the hash database and log file
    rm -f "$HASH_DB" "$LOG_FILE"

    # Remove the copy directory if it exists
    [[ -n "$COPY_DIR" && -d "$COPY_DIR" ]] && rm -rf "$COPY_DIR"

    # Quit the program
    sleep 5; quit

}

# Print the result screen and list all unique files
print_result () {

    local tab=0 prev=-1 max=0 screen=()

    # Print actions
    print_actions "TAB::Page" "BACK::Delete Results" "Q::Quit"

    # Print the title
    print_title "FILECOMP RESULTS"

    while true; do

        # Clear the screen
        clear_content

        # Read key input
        read_key

        # Check for commands
        case "$KEY" in
            "tab" )   tab=$(( ( $tab + 1 ) % $max )) ;;
            "back" )  delete_results ;;
            "quit" )  quit ;;
        esac

    done

}