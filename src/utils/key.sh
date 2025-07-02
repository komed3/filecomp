#!/bin/bash

# --------------------------------------------------------------------------------
# src/utils/input.sh
# User Key Input Recognition
#
# This script reads a single keypress and returns its human-readable name.
# It supports regular keys, control keys, and special keys (like arrow keys).
# --------------------------------------------------------------------------------

read_key () {

    # Clear any pending input
    while IFS= read -rs -n1 -t 0.01; do :; done

    # Read exactly one character in raw mode
    IFS= read -rs -n1 -d '' key
    
    # Check for escape sequence (likely a special key)
    if [[ "$key" == $'\e' ]]; then

        # Read next 2 characters with timeout (for escape sequences)
        IFS= read -rs -n2 -t 0.01 seq

        case "$seq" in
            "[A") echo "arrow_up" ;;
            "[B") echo "arrow_down" ;;
            "[C") echo "arrow_right" ;;
            "[D") echo "arrow_left" ;;
            "[5~") echo "page_up" ;;
            "[6~") echo "page_down" ;;
            *) echo 0 ;;
        esac

    else

        # Handle regular keys, convert control keys to readable names
        case "$key" in
            $'\t') echo "tab" ;;
            $'\n') echo "enter" ;;
            $'\b'|$'\x7f') echo "backspace" ;;
            $' ') echo "space" ;;
            [[:alnum:]]) echo "$key" ;;
            *) echo 0 ;;
        esac

    fi

}
