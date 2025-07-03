#!/bin/bash

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
            $'\e[A' ) KEY="arrow_up" ;;
            $'\e[B' ) KEY="arrow_down" ;;
            $'\e[C' ) KEY="arrow_right" ;;
            $'\e[D' ) KEY="arrow_left" ;;
            $'\e[5' ) KEY="page_up" ;;
            $'\e[6' ) KEY="page_down" ;;
        esac

    else

        # Handle regular keys
        # Convert control keys to readable names
        case "$key" in
            $' ' )           KEY="space" ;;
            $'\n'|$'\r'|"" ) KEY="enter" ;;
            $'\b'|$'\x7f' )  KEY="backspace" ;;
            $'\t' )          KEY="tab" ;;
            [[:alnum:]] )    KEY=$key ;;
        esac

    fi

    # Catch all following inputs (e.g. if the button is held down)
    while IFS= read -rsn1 -t 0.001 _; do :; done

}

prog_control () {

    case "$KEY" in
        "enter" )     (( PREV=STEP )); (( STEP++ )) ;;
        "backspace" ) (( STEP=PREV )) ;;
        [hH] )        (( PREV=STEP )); (( STEP=0 )) ;;
        [qQ] )        quit ;;
    esac

}
