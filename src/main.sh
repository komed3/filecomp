#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_DIR/utils/ui.sh"

main () {

    setup_env

    print_header
    print_footer

    reset_env

}

main
