#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_DIR/utils/ui.sh"
source "$SCRIPT_DIR/utils/key.sh"

source "$SCRIPT_DIR/help.sh"

main () {

    setup_env

    print_header
    print_footer

    KEK=""; STEP=0; PREV=0

    while true; do

        case $STEP in
            0 ) help ;;
        esac

        read_key
        prog_control

    done

    reset_env

}

main
