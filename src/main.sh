#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_DIR/utils/env.sh"
source "$SCRIPT_DIR/utils/ui.sh"

source "$SCRIPT_DIR/help.sh"

main () {

    check_available_hashes

    setup_env

    print_header
    print_footer

    print_help

    reset_env

}

main
