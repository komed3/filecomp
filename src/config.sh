#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/ui.sh"
source "$SCRIPT_DIR/utils/select.sh"

# Config variables
BASE_DIR=""
COMP_DIR=""
COPY_DIR=""

HASH_ALGO=0
OUTP_OPT=0
DB_DELETE=0

set_hash_algo () {

    # Print actions
    print_actions "UP/DN::Navigate" "SPACE::Select"

    # Print the title
    print_title "SELECT HASH ALGORITHM"

    # Menu to select from available hashes
    select_menu 0 1 0 AVAILABLE_HASHES

}

config_loop () {

    clear_content

    set_hash_algo

}