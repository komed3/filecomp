#!/bin/bash

# --------------------------------------------------------------------------------
# src/utils/check.sh
# Check Options
#
# Before running the comparison, this script lists the inputs made by the user
# and asks for confirmation to proceed.
# --------------------------------------------------------------------------------

source "$SCRIPT_DIR/utils/key.sh"
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/tui.sh"

check_options () {

    # Clear previous content
    clear_content

    # Print options / menu actions
    print_actions "[ENTER] Proceed and do the job" 2 "[Q] Quit"

    # The main loop
    # Check inputs made before run the comparison
    while true; do

        # Jump to content
        jump_content

        # Print the menu title
        print_title "CHECK YOUR INPUTS BEFORE PROCEED"

        local check_label=(
          "Base directory "
          "Compare with   "
          "Copy unique to?"
          "Hash algorithm "
          "Output option  "
          "Hash database  "
        )
        local check_value=(
          "$base_dir"
          "$comp_dir"
          "$copy_dir"
          "$hash_txt"
          "$outp_txt"
          "$hsdb_txt"
        )

        for i in "${!check_label[@]}"; do

            printf "%s%s  :  %s%s%s\n" \
                "$PRFX" "${check_label[i]}" \
                "$BOLD" "${check_value[i]}" \
                "$RESET"

        done

        printf "\n%s%s%s%s" "$PRFX" "$RED" "(Abort by quitting the program)" "$RESET"

        # Parse key input
        case "$( read_key )" in

            # Enter: continue to next step
            "enter") break ;;

            # Quit program
            [qQ]) quit ;;

        esac

    done

}
