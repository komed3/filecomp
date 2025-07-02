#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_DIR/utils/ui.sh"
source "$SCRIPT_DIR/utils/key.sh"

main () {

    setup_env

    print_header
    print_footer

    PREV=0; STEP=0

    while true; do

        KEY=$( read_key )

        prog_control

    done

    reset_env

}

main
