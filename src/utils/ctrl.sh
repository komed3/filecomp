#!/bin/bash

source "$SCRIPT_DIR/utils/ui.sh"

KEY=""

read_key () {

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
            $'\e[A' ) KEY="up" ;;
            $'\e[B' ) KEY="down" ;;
            $'\e[C' ) KEY="right" ;;
            $'\e[D' ) KEY="left" ;;
            $'\e[5' ) KEY="prev" ;;
            $'\e[6' ) KEY="next" ;;
            * )       KEY=0
        esac

    else

        # Handle regular keys
        # Convert control keys to readable names
        case "$key" in
            [qQ] )           KEY="quit" ;;
            $' ' )           KEY="space" ;;
            $'\n'|$'\r'|"" ) KEY="enter" ;;
            $'\t' )          KEY="tab" ;;
            * )              KEY=0
        esac

    fi

    # Catch all following inputs (e.g. if the button is held down)
    while IFS= read -rsn1 -t 0.001 _; do :; done

}

quit () {
    reset_env
}

await_to_proceed () {

    while true; do

        read_key

        case "$KEY" in
            "enter" ) break ;;
            "quit" ) quit ;;
        esac

    done

}
