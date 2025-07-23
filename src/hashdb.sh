#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/ui.sh"
source "$SCRIPT_DIR/utils/log.sh"
source "$SCRIPT_DIR/utils/progress.sh"
source "$SCRIPT_DIR/utils/ctrl.sh"

# Path for storing hash values
HASH_DB="$PWD/.filecomp_hashdb"

# Create a hash database for all files in the given directory
create_hashdb () {

    # Get number of threads
    local -i th=${THREADS[$N_THREADS]}

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
    print_title "CREATE INITIAL HASH DATABASE"

    # Clear the live log
    clear_log

    # Print initial log messages
    update_log "Use ${BOLD}${algo}${RESET} hash algorithm"
    update_log "Run hashing on ${BOLD}${th} thread(s)${RESET}"
    update_log "Scanning directory: ${YELLOW}${BASE_DIR}${RESET} …"
    update_log "This may take some time …"
    update_log ""

    # Collect all regular files (exclude broken symlinks etc.)
    mapfile -t files < <( find "$BASE_DIR" -type f -readable -print )
    local -i total=${#files[@]}

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
        update_log "Initiate hash database: ${YELLOW}${HASH_DB}${RESET} …"
        update_log "";
        : > "$HASH_DB"

        # Loop trought files
        local -i next_log=0
        local -i i

        for (( i=0; i < total; i++ )); do

            # Get file
            local file="${files[$i]}"

            # Use a subshell to avoid blocking the main script
            # and to allow parallel execution
            (
                if hash_output=$( "$cmd" "$file" 2>/dev/null ); then
                    local hash_value="${hash_output%% *}"
                    echo "$hash_value ${files[$i]}" >> "$HASH_DB"
                fi
            ) &

            # Run as many threads as allowed
            if (( ( i + 1 ) % th == 0 )); then wait; fi

            # Update progress bar
            progress_update $(( $i + 1 ))

            # Log current progress rate (only if more than 10k files)
            if (( total > 10000 && i * 10 / total > next_log )); then
                update_log "${BOLD}${i}${RESET} of ${BOLD}${total}${RESET} files processed, $( progress_rate ) files/sec …"
                next_log=$(( $i * 10 / $total ))
            fi

            # Check for non-blocking user input to quit
            may_quit

        done

        # Finish the process
        progress_finish
        update_log ""
        update_log "${GREEN}Hash database was created successfully${RESET}"
        update_log "${GREEN}Finished after ${BOLD}$( progress_duration )${RESET}"
        status=0

    fi

    # Await user input
    await_to_proceed

}
