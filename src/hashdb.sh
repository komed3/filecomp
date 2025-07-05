#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/ui.sh"
source "$SCRIPT_DIR/utils/progress.sh"
source "$SCRIPT_DIR/utils/spinner.sh"
source "$SCRIPT_DIR/utils/ctrl.sh"

create_hashdb () {

    # Print actions
    print_actions "SPACE::Pause"

    # Print the title
    print_title "CREATE INITIAL HASH DATABASE"

    # Clear previous content
    clear_content

    await_to_proceed

}
