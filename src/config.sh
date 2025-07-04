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

# Set the alorithm for hashing
set_hash_algo () {

    # Print the title
    print_title "SELECT HASH ALGORITHM"

    # Menu to select algorithm from available hashes
    select_menu 0 1 0 AVAILABLE_HASHES

    # Save the selected hash algorithm
    HASH_ALGO=${result[0]}

}

# Loop to configure the script
config_loop () {

    # Clear previous content
    clear_content

    # Step 1: Set hash algorithm
    set_hash_algo

}
