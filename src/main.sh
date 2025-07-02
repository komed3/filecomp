#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_DIR/utils/tui.sh"

source "$SCRIPT_DIR/utils/select.sh"
source "$SCRIPT_DIR/utils/folder.sh"

# Main program
main () {

    # Clear and setup screen
    clear; setup_screen

    # Print the program header
    print_header

    # Print the program footer
    print_footer

    # Main programm

    # Step 1: select hash algorithm (default 'SHA1')
    hash_opts=( "SHA1" "SHA256" "MD5" )
    hash_init=( 1 0 0 )

    select_menu "SELECT HASH ALGORITHM FOR COMPARING FILES" \
        0 1 0 hash_opts hash_init

    hash_idx=${result[0]}
    hash_algo="${hash_opts[$hash_idx]}"

    # Quit the program safely
    quit

}

# Run the programm
main
