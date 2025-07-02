#!/bin/bash

source "$SCRIPT_DIR/utils/ui.sh"

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
            $'\e[A' ) echo "arrow_up" ;;
            $'\e[B' ) echo "arrow_down" ;;
            $'\e[C' ) echo "arrow_right" ;;
            $'\e[D' ) echo "arrow_left" ;;
            $'\e[5' ) echo "page_up" ;;
            $'\e[6' ) echo "page_down" ;;
            * )       echo 0 ;;
        esac

    else

        # Handle regular keys
        # Convert control keys to readable names
        case "$key" in
            $' ' )           echo "space" ;;
            $'\n'|$'\r'|"" ) echo "enter" ;;
            $'\b'|$'\x7f' )  echo "backspace" ;;
            $'\t' )          echo "tab" ;;
            [[:alnum:]] )    echo $key ;;
            * )              echo 0 ;;
        esac

    fi

    # Catch all following inputs (e.g. if the button is held down)
    while IFS= read -rsn1 -t 0.001 _; do :; done

}

eval_key () {

    case "$KEY" in
        [qQ] ) quit ;;
    esac

}
