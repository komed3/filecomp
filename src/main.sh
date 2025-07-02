#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_DIR/utils/tui.sh"
source "$SCRIPT_DIR/utils/help.sh"
source "$SCRIPT_DIR/utils/select.sh"
source "$SCRIPT_DIR/utils/folder.sh"

# The main program with all steps
main () {

    # PREPARE SCREEN

    # Clear and setup screen
    clear; setup_screen

    # Print the program header
    print_header

    # Print the program footer
    print_footer

    # MAIN PROGRAM

    # Step 0: Show the intro / help screen
    output_help

    # Step 1: select base directory
    select_folder "SELECT BASE DIRECTORY" "$HOME"
    base_dir=${result}

    # Step 2: select directory to compare
    select_folder "SELECT DIRECTORY TO COMPARE" "$HOME"
    comp_dir=${result}

    # Step 3: select hash algorithm (default 'SHA1')
    hash_opts=( "SHA1" "SHA256" "MD5" "B2SUM" )
    hash_init=( 1 0 0 0 )

    select_menu "SELECT HASH ALGORITHM FOR COMPARING FILES" \
        0 1 0 hash_opts hash_init

    hash_opt=${result[0]}
    hash_txt="${hash_opts[$hash_opt]}"

    # Step 4: select output option (default 'log')
    outp_opts=( "Write files to log" "Copy files to new directory" "Both options" )
    outp_init=( 1 0 0 )

    select_menu "SELECT OUTPUT OPTION FOR UNIQUE FILES" \
        0 1 0 outp_opts outp_init

    outp_opt=${result[0]}
    outp_txt="${outp_opts[$outp_opt]}"

    # Step 4.a: If desired, select directory to copy files to
    if (( outp_opt != 0 )) then
        select_folder "SELECT DIRECTORY FOR TO COPY UNIQUE FILES TO" "$HOME"
        uniq_dir=${result}
    else uniq_dir=""; fi

    # Step 5: keep / delete hash database (default 'keep')
    hsdb_opts=( "Keep it" "Delete it" )
    hsdb_init=( 1 0 )

    select_menu "HOW TO PROCEED WITH HASH DATABASE" \
        0 1 0 hsdb_opts hsdb_init

    hsdb_opt=${result[0]}
    hsdb_txt="${hsdb_opts[$hsdb_opt]}"

    # Quit the program safely
    quit

}

# Execute the programm
main
