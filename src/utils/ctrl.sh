#!/bin/bash

source "$SCRIPT_DIR/utils/ui.sh"

read_input () {

    local key rest seq

    # Read raw terminal inputs
    IFS= read -rsn1 key 2>/dev/null || return

    # Escape sequence (arrow, function keys)
    if [[ "$key" == $'\e' ]]; then

        # Read next 2 characters with timeout (for escape sequences)
        IFS= read -rsn1 -t 0.005 rest 2>/dev/null
        key+="$rest"
        IFS= read -rsn1 -t 0.001 seq 2>/dev/null
        key+="$seq"

        # Parse special keys
        case "$key" in
            $'\e[A' ) echo "up" ;;
            $'\e[B' ) echo "down" ;;
            $'\e[C' ) echo "right" ;;
            $'\e[D' ) echo "left" ;;
            $'\e[5' ) echo "prev" ;;
            $'\e[6' ) echo "next" ;;
            * )       echo 0
        esac

    else

        # Handle regular keys
        # Convert control keys to readable names
        case "$key" in
            [qQ] )           echo "quit" ;;
            $' ' )           echo "space" ;;
            $'\n'|$'\r'|"" ) echo "enter" ;;
            $'\t' )          echo "tab" ;;
            * )              echo 0
        esac

    fi

    # Catch all following inputs (e.g. if the button is held down)
    while IFS= read -rsn1 -t 0.001 _; do :; done

}

quit () {
    reset_env
}

await_next () {

    while true; do

        case "$( read_input )" in
            "enter" ) break ;;
            "quit" ) quit ;;
        esac

    done

}
