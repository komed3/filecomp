#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/ui.sh"
source "$SCRIPT_DIR/utils/log.sh"
source "$SCRIPT_DIR/utils/progress.sh"
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
    print_actions

    # Print the title
    print_title "CREATE INITIAL HASH DATABASE USING $algo"

    # Clear the live log
    clear_log

    # Print initial log messages
    update_log "Scanning directory: ${BOLD}${BASE_DIR}${RESET}"
    update_log "This may take some time …"
    update_log ""

    # Collect all regular files (exclude broken symlinks etc.)
    mapfile -t files < <( find "$BASE_DIR" -type f -readable -print )
    local total=${#files[@]}

    # Print error msg if no readable files where found
    if (( total == 0 )); then

        update_log "${RED}No readable files found in: ${BASE_DIR}${RESET}"
        status=1

    # Proceed the files
    else

        # Log the number of files
        update_log "Found ${BOLD}${total}${RESET} files, proceed now …"

        # Start progress bar
        progress_init $total

        # Create/overwrite hash database
        update_log "Initiate hash database: ${HASH_DB} …"
        : > "$HASH_DB"

        # Loop trought files
        local i
        for (( i=0; i < total; i++ )); do

            # Get file
            local file="${files[$i]}"

            # Calculate hash and save to database
            if hash_output=$( "$cmd" "$file" 2>/dev/null ); then

                local hash_value="${hash_output%% *}"

                # Log the hashed file
                echo "$hash_value $file" >> "$HASH_DB"
                update_log "Indexed: ${file}"

            # If the hashing failed, log it
            else update_log "${RED}Failed: ${file}${RESET}"; fi

            # Update progress bar
            progress_update $(( $i + 1 ))

        done

        # Finish the process
        progress_finish; update_log "${GREEN}Hash database created: ${HASH_DB}${RESET}"
        status=0

    fi

    await_to_proceed

}
