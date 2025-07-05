#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/ui.sh"
source "$SCRIPT_DIR/utils/ctrl.sh"

select_folder () {

    # Print actions
    print_actions "UP/DN::Navigate" "LT/RT::Change directory" "PGUP/PGDN::Pages"

    # Clear the content
    clear_content

    await_to_proceed

}