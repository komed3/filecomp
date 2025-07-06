#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/ui.sh"
source "$SCRIPT_DIR/utils/ctrl.sh"
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

# Set the directory for copying unique files to
select_copy_dir () {

    if (( OUTP_OPT != 0 )) then

        # Print the title
        print_title "SELECT DIRECTORY TO COPY UNIQUE FILES TO"

        # Menu to select directory
        select_folder $HOME

        # Save the selected directory
        COPY_DIR=$result

    fi

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

check_options () {

    # Print actions
    print_actions "BACK::Correct"

    # Print the title
    print_title "CHECK YOUR INPUTS BEFORE PROCEED"

    # Clear the content
    clear_content

    local check_label=(
        "Base directory" "Compare with  " "Copy unique to"
        "Hash algorithm" "Output option " "Hash database "
    )

    local check_value=(
        "$BASE_DIR" "$COMP_DIR" "$COPY_DIR"
        "${AVAILABLE_HASHES[$HASH_ALGO]}"
        "${OUTP_OPTS[$OUTP_OPT]}"
        "${DB_DELETE_OPTS[$DB_DELETE]}"
    )

    # Print list of options
    for i in "${!check_label[@]}"; do

        printf "%s%s  :  %s%s%s\n" \
            "$PRFX" "${check_label[$i]}" \
            "$CYAN$BOLD" "${check_value[$i]:-"N/A"}" \
            "$RESET"

    done

    printf "\n%sAbort by %squitting%s the program, use %sBackspace%s to correct inputs." \
        "$PRFX" "$BOLD" "$RESET" "$BOLD" "$RESET"
    printf "\n%sHit %sEnter%s when ready to proceed." "$PRFX" "$BOLD" "$RESET"

}

# Loop to configure the script
config_loop () {

    while true; do

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
        select_copy_dir

        # Step 5: Keep or delete database
        keep_or_delete_db

        # Check inputs / options
        check_options

        # Await for user action
        while true; do

            # Read key input
            read_key

            # Check for commands
            case "$KEY" in
                "back" )
                    BASE_DIR=""; COMP_DIR=""; COPY_DIR=""
                    HASH_ALGO=0; OUTP_OPT=0; DB_DELETE=0
                    break ;;
                "enter" ) break 2 ;;
                "quit" )  quit ;;
            esac

        done

    done

}
