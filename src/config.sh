#!/bin/bash

source "$SCRIPT_DIR/utils/ctrl.sh"
source "$SCRIPT_DIR/utils/ui.sh"

BASE_DIR=""
COMP_DIR=""
COPY_DIR=""

HASH_ALGO=0
OUTP_OPT=0
DB_DELETE=0

set_hash_algo () {

    # Print actions
    print_actions "UP/DN::Navigate"

    # Print the title
    print_title "SELECT HASH ALGORITHM"

    await_to_proceed

}

config_loop () {

    clear_content

    set_hash_algo

}