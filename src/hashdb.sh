#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/ui.sh"
source "$SCRIPT_DIR/utils/log.sh"
source "$SCRIPT_DIR/utils/progress.sh"
source "$SCRIPT_DIR/utils/ctrl.sh"

# Path for storing hash values
HASH_DB="$PWD/.filecomp_hashdb"

# Hashing progress
HASH_PG=0

# Recursively hash all files in a directory
# Arguments:
#   $1: Directory to process
#   $2: Command to use for hashing (e.g., sha256sum)
hashdir_recursive () {

    local dir="$1"
    local cmd="$2"

    update_log "Processing directory: ${YELLOW}${dir}${RESET} …"

    # Hash all regular files in this directory (non-recursive)
    local file
    for file in "$dir"/*; do

        if [[ -f "$file" && -r "$file" ]]; then
            if hash_output=$( "$cmd" "$file" 2>/dev/null ); then
                local hash_value="${hash_output%% *}"
                echo "$hash_value $file" >> "$HASH_DB"
                progress_update $(( ++HASH_PG ))
            fi
        fi

        may_quit

    done

    # Recurse into subdirectories
    local sub
    for sub in "$dir"/*; do

        if [[ -d "$sub" && -r "$sub" ]]; then
            hashdir_recursive "$sub" "$cmd"
        fi

        may_quit

    done

}

# Create a hash database for all files in the given directory
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
    print_title "CREATE INITIAL HASH DATABASE USING ${BOLD}${algo}${RESET}"

    # Clear the live log
    clear_log

    # Print initial log messages
    update_log "Scanning directory: ${YELLOW}${BASE_DIR}${RESET}"
    update_log "This may take some time …"
    update_log ""

    # Collect all regular files (exclude broken symlinks etc.)
    mapfile -t files < <( find "$BASE_DIR" -type f -readable -print )
    local total=${#files[@]}

    # Print error msg if no readable files where found
    if (( total == 0 )); then

        update_log "${RED}No readable files found in: ${BOLD}${BASE_DIR}${RESET}"
        status=1

    # Proceed the files
    else

        # Log the number of files
        update_log "Found ${BOLD}${total}${RESET} files, proceed now …"

        # Start progress bar
        progress_init $total

        # Create/overwrite hash database
        update_log "Initiate hash database: ${YELLOW}${HASH_DB}${RESET}"
        : > "$HASH_DB"

        # Start recursive hashing
        hashdir_recursive "$BASE_DIR" "$cmd"

        # Finish the process
        progress_finish
        update_log "${GREEN}Hash database created: ${$BOLD}${HASH_DB}${RESET}"
        status=0

    fi

    await_to_proceed

}
