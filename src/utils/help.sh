#!/bin/bash

# --------------------------------------------------------------------------------
# src/utils/help.sh
# Help
#
# This file will show the help / intro screen for the file comparison program.
# It is used to display the options and actions available in the program.
# --------------------------------------------------------------------------------

source "$SCRIPT_DIR/utils/key.sh"
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/tui.sh"

output_help () {

    # Clear previous content
    clear_content

    # Print options / menu actions
    print_actions "[ENTER] Proceed" 2 "[Q] Quit"

    # The main loop
    # Show helpful information
    while true; do

        # Jump to content
        jump_content

        # Print the menu title
        print_title "WELCOME TO FILECOMP"

        local help=(
          "FileComp recursively compares two directories for unique files using their hash values."
          ""
          "${BOLD}Steps:${RESET}"
          "1) Select base directory."
          "2) Select directory to compare."
          "3) Choose hash algorithm (e.g., SHA1)."
          "4) Choose output: log, copy, or both."
          "5) (Optional) Select folder to copy unique files."
          "6) Decide whether to keep or delete hash DB."
          ""
          "Use ${BOLD}arrow keys${RESET} and ${BOLD}Enter${RESET} to navigate menus."
          "Press ${BOLD}Q${RESET} anytime to quit."
        )

        for i in "${!help[@]}"; do printf "%s%s\n" "$PRFX" "${help[i]}"; done

        # Parse key input
        case "$( read_key )" in

            # Enter: continue to next step
            "enter") break ;;

            # Quit program
            [qQ]) quit ;;

        esac

    done

}
