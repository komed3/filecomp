#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/ui.sh"
source "$SCRIPT_DIR/utils/ctrl.sh"

# Delete all results and files
delete_results () {

    # ...

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