#!/bin/bash

# --------------------------------------------------------------------------------
# src/hashdb.sh
# Create Hash Database
#
# This script builds a hash database by recursively walking a base directory
# and recording hash values for each file found. Temp. database file is used
# for later comparisons to detect unique files.
#
# Function: build_hash_db
# Parameters:
# $1 - Base directory
# $2 - Hash algorithm (SHA1 | SHA256 | MD5 | B2SUM)
# Return:
# Status '0' if succeeded, '1' if failed
# --------------------------------------------------------------------------------

source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/tui.sh"
source "$SCRIPT_DIR/utils/log.sh"
source "$SCRIPT_DIR/utils/pgbar.sh"

# Temporary path for storing hash values
temp_hash_db="$PWD/.filecomp_hash_db"

# Build hash database
build_hash_db () {

    local base_dir="$1"
    local algo="$2"

    # Determine hash command
    local cmd

    case "$algo" in
        "SHA1")   cmd="sha1sum" ;;
        "SHA256") cmd="sha256sum" ;;
        "MD5")    cmd="md5sum" ;;
        "B2SUM")  cmd="b2sum" ;;
    esac

    # Print options / menu actions
    print_actions "[Q] Quit"

    # Clear previous content
    clear_content

    # Print the title
    print_title "CREATE HASH DATABASE USING $algo"

    # Clear the live log
    clear_log

    # Print initial log messages
    update_log "Scanning directory: $base_dir"
    update_log "This may take some time …"
    update_log "";

    # Collect all regular files (exclude broken symlinks etc.)
    mapfile -t files < <( find "$base_dir" -type f -readable -print )
    local total=${#files[@]}

    # Print error msg if no readable files where found
    if (( total == 0 )); then

        update_log "No readable files found in: $base_dir"
        status=1

    # Proceed the files
    else

        # Log the number of files
        update_log "Found $total files, proceed now …"

        # Start progress bar
        pgbar_init $total

        # Create/overwrite hash database
        : > "$temp_hash_db"

        # Loop trought files
        local i
        for (( i=0; i < total; i++ )); do

            local file="${files[$i]}"

            # Calculate hash and save to database
            if hash_output=$( "$cmd" "$file" 2>/dev/null ); then

                local hash_value="${hash_output%% *}"

                echo "$hash_value $file" >> "$temp_hash_db"
                update_log "Indexed: $file"

            else update_log "Failed: $file"; fi

            # Update progress bar
            pgbar_update $(( i + 1 ))

        done

        # Finish the process
        pgbar_finish; update_log "Hash database created: $temp_hash_db"
        status=0

    fi

}
