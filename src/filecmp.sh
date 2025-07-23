#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/ui.sh"
source "$SCRIPT_DIR/utils/log.sh"
source "$SCRIPT_DIR/utils/progress.sh"
source "$SCRIPT_DIR/utils/ctrl.sh"

# Path for log file
LOG_FILE="$PWD/.filecomp_unique.log"

# Compare files against the hash database
compare_files () {

    # Get number of threads
    local -i th=${THREADS[$N_THREADS]}

    # Print actions
    print_actions

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

        update_log "";

        # Loop trought files
        local -i unique=0
        local -i next_log=0
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
                        (
                            flock 200
                            if (( $OUTP_OPT != 1 )); then echo "$file" >> "$LOG_FILE"; fi
                            if (( $OUTP_OPT != 0 )); then cp -a "$file" "$COPY_DIR/"; fi
                        ) 200>"$logfile.lock"

                        # Increment counter
                        (( unique++ ))

                    fi

                fi

            ) &

            # Run as many threads as allowed
            if (( ( i + 1 ) % th == 0 )); then wait; fi

            # Update progress bar
            progress_update $(( $i + 1 ))

            # Log current progress rate (only if more than 10k files)
            if (( total > 10000 && i * 10 / total > next_log )); then
                update_log "${BOLD}${i}${RESET} of ${BOLD}${total}${RESET} files processed and ${BOLD}${unique}${RESET} unique found, $( progress_rate ) files/sec …"
                next_log=$(( $i * 10 / $total ))
            fi

            # Check for non-blocking user input to quit
            may_quit

        done

        # Finish the process
        wait; progress_finish; status=0
        update_log ""
        update_log "${GREEN}Comparison finished: ${BOLD}${unique} unique files${RESET}"
        update_log "${GREEN}Finished after ${BOLD}$( progress_duration )${RESET}"

    fi

    # Await user input
    await_to_proceed

}
