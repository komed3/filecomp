#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/ui.sh"
source "$SCRIPT_DIR/utils/ctrl.sh"

print_result () {

    # Print actions
    print_actions "TAB::Page" "BACK::Delete Results"

    # Print the title
    print_title "RESULTS"

    while true; do

        # Clear the screen
        clear_content

        # Read key input
        read_key

        # Check for commands
        case "$KEY" in
            "tab" )   ;;
            "back" )  ;;
            "enter" ) break ;;
            "quit" )  quit ;;
        esac

    done

}