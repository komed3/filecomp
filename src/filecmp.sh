#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/env.sh"
source "$SCRIPT_DIR/utils/ui.sh"
source "$SCRIPT_DIR/utils/log.sh"
source "$SCRIPT_DIR/utils/progress.sh"
source "$SCRIPT_DIR/utils/ctrl.sh"

# Path to log file
LOG_FILE="$PWD/.filecomp_unique.log"

# Compare files against the hash database
compare_files () {

    # Get number of threads
    local -i th=${THREADS[$N_THREADS]}

    # Print actions
    print_actions "Q::Quit"

    # Print the title
    print_title "COMPARE FILES AGAINST DATABASE"

    # Clear the live log
    clear_log

    # Print initial log messages
    update_log "Use ${BOLD}${AVAILABLE_HASHES[$HASH_ALGO]}${RESET} hash algorithm"
    update_log "Run comparison on ${BOLD}${th} thread(s)${RESET}"
    update_log "Use hash database: ${YELLOW}${HASH_DB}${RESET}"
    update_log "Scanning directory: ${YELLOW}${COMP_DIR}${RESET} …"
    update_log "This may take some time …"
    update_log ""

    # Collect all regular files (exclude broken symlinks etc.)
    mapfile -t files < <( find "$COMP_DIR" -type f -readable -print )
    local -i total=${#files[@]}

    # Print error msg if no readable files where found
    if (( total == 0 )); then

        update_log "${RED}No readable files found in: ${BOLD}${COMP_DIR}${RESET}"
        status=1

    # Proceed the files
    else

        # Clear temp file
        clear_tmp

        # Log the number of files
        update_log "Found ${BOLD}${total}${RESET} files, proceed now …"

        # Start progress bar
        progress_init $total

        # Load hash database into associative array for fast lookup
        update_log "Load hash database into associative array for fast lookup …"
        declare -A HASHES
        while read -r hash path; do HASHES["$hash"]=1; done < "$HASH_DB"

        # Prepare log file if needed
        if (( $OUTP_OPT != 1 )); then
            update_log "Initiate log file: ${YELLOW}${LOG_FILE}${RESET} …"
            : > "$LOG_FILE"
        fi

        # Create copy dir if needed
        if (( $OUTP_OPT != 0 )); then
            update_log "Create copy dir: ${YELLOW}${COPY_DIR}${RESET} …"
            mkdir -p "$COPY_DIR"
        fi

        # Loop trought files
        update_log ""
        update_log "Compare files …"
        update_log ""

        local -i i

        for (( i=0; i < total; i++ )); do

            (

                # Get file
                local file="${files[$i]}"

                # Try to hash
                if hash_output=$( "$HASH_CMD" "${files[$i]}" 2>/dev/null ); then

                    # Extract hash value
                    local hash_value="${hash_output%% *}"

                    # Check if hash exists in database
                    if [[ -z "${HASHES[$hash_value]}" ]]; then

                        # File is unique, log it
                        echo "$file" >> "$TMP_FILE"
                        if (( $OUTP_OPT != 1 )); then echo "$file" >> "$LOG_FILE"; fi
                        if (( $OUTP_OPT != 0 )); then cp -a "$file" "$COPY_DIR/"; fi

                    fi

                fi

            ) &

            # Run as many threads as allowed
            if (( ( i + 1 ) % th == 0 )); then wait; fi

            # Update progress bar
            progress_update $(( $i + 1 ))

            # Update log with current processing rate
            if (( i > 0 && i % 500 == 0 )); then
                update_log_last "Current processing rate: ${BOLD}$( progress_rate )${RESET} files/sec …"
            fi

            # Check for non-blocking user input to quit
            may_quit

        done

        # Finish the process
        wait; progress_finish; status=0
        update_log ""
        update_log "${GREEN}Comparison finished: ${BOLD}$( wc -l < "$TMP_FILE" ) unique files${RESET}"
        update_log "${GREEN}Finished after ${BOLD}$( progress_duration )${RESET}"
        print_actions "ENTER::Proceed" "Q::Quit"

    fi

    # Await user input
    await_to_proceed

    # Clear progress bar
    progress_clear

}
