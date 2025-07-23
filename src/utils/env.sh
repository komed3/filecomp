#!/bin/bash

# Environment variables
AVAILABLE_HASHES=()
MAX_THREADS=$( nproc 2>/dev/null || echo 1 )

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
