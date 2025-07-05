#!/bin/bash

# Directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Load utility scripts
source "$SCRIPT_DIR/utils/env.sh"
source "$SCRIPT_DIR/utils/ui.sh"

# Load program parts
source "$SCRIPT_DIR/help.sh"
source "$SCRIPT_DIR/config.sh"
source "$SCRIPT_DIR/hashdb.sh"

# Main container function
# This function orchestrates the execution of the script
main () {

    # Check environment and dependencies
    check_available_hashes

    # Set up the environment
    setup_env

    # Print the header and footer
    print_header
    print_footer

    # Print the help screen
    print_help

    # Start the preparation for file comparison
    config_loop

    # Create the hash database
    create_hashdb

    # Reset the environment to quit safely
    reset_env

}

# Execute the main function
main
