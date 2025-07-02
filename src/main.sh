#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_DIR/utils/ui.sh"
source "$SCRIPT_DIR/utils/key.sh"

main () {

    setup_env

    while true; do

        KEY=$( read_key )

        echo "$KEY"

    done

    reset_env

}

main
