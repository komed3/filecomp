#!/bin/bash

# Environment variables
AVAILABLE_HASHES=()

# Check available hash commands and populate AVAILABLE_HASHES
check_available_hashes () {

    # Map: Algorithm → Command
    declare -A hash_cmds=(
        [SHA1]="sha1sum"
        [SHA256]="sha256sum"
        [SHA512]="sha512sum"
        [MD5]="md5sum"
        [B2]="b2sum"
    )

    AVAILABLE_HASHES=()

    for name in "${!hash_cmds[@]}"; do
        if command -v "${hash_cmds[$name]}" >/dev/null 2>&1; then
            AVAILABLE_HASHES+=( "$name" )
        fi
    done

}