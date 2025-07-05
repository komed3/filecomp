#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/ui.sh"
source "$SCRIPT_DIR/utils/progress.sh"
source "$SCRIPT_DIR/utils/spinner.sh"
source "$SCRIPT_DIR/utils/ctrl.sh"

# Path for storing hash values
HASH_DB="$PWD/.filecomp_hashdb"

create_hashdb () {

    # Determine hash command
    local algo="${AVAILABLE_HASHES[$HASH_ALGO]}" cmd=""

    case "$algo" in
        "SHA1" )   cmd="sha1sum" ;;
        "SHA256" ) cmd="sha256sum" ;;
        "SHA512" ) cmd="sha256sum" ;;
        "B2" )     cmd="b2sum" ;;
        "MD5" )    cmd="md5sum" ;;
    esac

    # Print actions
    print_actions "SPACE::Pause"

    # Print the title
    print_title "CREATE INITIAL HASH DATABASE USING $algo"

    # Clear previous content
    clear_content

    await_to_proceed

}
