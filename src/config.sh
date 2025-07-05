#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/ui.sh"
source "$SCRIPT_DIR/utils/select.sh"
source "$SCRIPT_DIR/utils/folder.sh"

# Config variables
BASE_DIR=""
COMP_DIR=""
COPY_DIR=""

HASH_ALGO=0
OUTP_OPT=0
DB_DELETE=0

OUTP_OPTS=( "Write files to log" "Copy files to new directory" "Both options" )
DB_DELETE_OPTS=( "Keep it" "Delete it" )

# Set the base directory
select_base_dir () {

    # Print the title
    print_title "SELECT BASE DIRECTORY"

    # Menu to select directory
    select_folder $HOME

    # Save the selected directory
    BASE_DIR=$result

}

# Set the directory for comparison
select_comp_dir () {

    # Print the title
    print_title "SELECT DIRECTORY TO COMPARE"

    # Menu to select directory
    select_folder $HOME

    # Save the selected directory
    COMP_DIR=$result

}

# Set the alorithm for hashing
set_hash_algo () {

    # Print the title
    print_title "SELECT HASH ALGORITHM"

    # Menu to select algorithm from available hashes
    select_menu 0 1 0 AVAILABLE_HASHES

    # Save the selected hash algorithm
    HASH_ALGO=${result[0]}

}

# Set the option for dealing with unique files
set_output_option () {

    # Print the title
    print_title "SELECT OUTPUT OPTION FOR UNIQUE FILES"

    # Menu to select output option
    select_menu 0 1 0 OUTP_OPTS

    # Save the selected output options
    OUTP_OPT=${result[0]}

}

# Decide whether to keep or delete the database
keep_or_delete_db () {

    # Print the title
    print_title "HOW TO PROCEED WITH HASH DATABASE"

    # Menu to decide about the database
    select_menu 0 1 0 DB_DELETE_OPTS

    # Save the decision
    DB_DELETE=${result[0]}

}

# Loop to configure the script
config_loop () {

    # Clear previous content
    clear_content

    # Step 1: Select base directory
    select_base_dir

    # Step 2: Select directory to compare
    select_comp_dir

    # Step 3: Set hash algorithm
    set_hash_algo

    # Step 4: Select output option
    set_output_option

    # Step 4a: If needed, select copy directory
    #...

    # Step 5: Keep or delete database
    keep_or_delete_db

}
