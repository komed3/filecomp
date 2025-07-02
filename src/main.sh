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

    hash_opt=${result[0]}
    hash_txt="${hash_opts[$hash_opt]}"

    # Step 2: select output option (default 'log')
    outp_opts=( "Write files to log" "Copy files to new directory" "Both options" )
    outp_init=( 1 0 0 )

    select_menu "SELECT OUTPUT OPTION FOR UNIQUE FILES" \
        0 1 0 outp_opts outp_init

    outp_opt=${result[0]}
    outp_txt="${outp_opts[$outp_opt]}"

    # Step 3: keep / delete hash database (default 'keep')
    hsdb_opts=( "Keep it" "Delete it" )
    hsdb_init=( 1 0 )

    select_menu "HOW TO PROCEED WITH HASH DATABASE" \
        0 1 0 hsdb_opts hsdb_init

    hsdb_opt=${result[0]}
    hsdb_txt="${hsdb_opts[$hsdb_opt]}"

    # Quit the program safely
    quit

}

# Run the programm
main
