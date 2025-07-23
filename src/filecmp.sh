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

            # ...

        done

    fi

    # Await user input
    await_to_proceed

}
