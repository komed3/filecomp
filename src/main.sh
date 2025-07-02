#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_DIR/utils/ui.sh"
source "$SCRIPT_DIR/utils/key.sh"

main () {

    setup_env

    STEP=0

    while true; do

        KEY=$( read_key )

        eval_key

    done

    reset_env

}

main
