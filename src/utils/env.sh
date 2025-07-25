#!/bin/bash

# Environment variables
TMP_FILE="${TMPDIR:-/tmp}/.filecomp"
MAX_THREADS=1
THREADS=()
AVAILABLE_HASHES=()

# Setup environment and trap exit signals to quit safely
setup_env () {

    # Store the current terminal settings
    ENV_STTY=$( stty -g )

    # Trapping signals to reset the environment on exit
    trap 'reset_env' INT TERM EXIT

    # Setup terminal for FileComp
    stty -icanon -echo min 1 time 0
    clear; tput civis

}

# Reset environment and restore terminal settings
reset_env () {

    # Remove temporary files
    [[ -f "$TMP_FILE" ]] && rm "$TMP_FILE"

    # Kill all background jobs
    local pids=$( jobs -p )
    if [[ -n "$pids" ]]; then
        for pid in $pids; do
            kill "$pid" 2>/dev/null
        done
        wait
    fi

    # Restore terminal settings
    stty "$ENV_STTY"
    tput sgr0; tput cnorm

    clear; exit 0

}

# Clear the temp file
clear_tmp () {
    : > "$TMP_FILE"
}

# Check available threads and populate THREADS
check_threads () {

    # Get the maximum number of threads available
    MAX_THREADS=$( nproc 2>/dev/null || echo 1 )

    # Loop through powers of 2 up to MAX_THREADS
    for (( i=1; i < MAX_THREADS; i *= 2 )); do
        THREADS+=( $i )
    done

    # Add the maximum threads option
    THREADS+=( $MAX_THREADS )

}

# Check available hash commands and populate AVAILABLE_HASHES
check_available_hashes () {

    # Map: Algorithm → Command
    declare -A hash_cmds=(
        [SHA1]="sha1sum"
        [SHA256]="sha256sum"
        [SHA512]="sha512sum"
        [B2]="b2sum"
        [MD5]="md5sum"
    )

    AVAILABLE_HASHES=()

    # Loop through the hash commands
    for name in SHA1 SHA256 SHA512 B2 MD5; do
        if command -v "${hash_cmds[$name]}" >/dev/null 2>&1; then
            AVAILABLE_HASHES+=( "$name" )
        fi
    done

}
