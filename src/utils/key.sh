#!/bin/bash

# --------------------------------------------------------------------------------
# src/utils/input.sh
# User Key Input Recognition
#
# This script reads a single keypress and returns its human-readable name.
# It supports regular keys, control keys, and special keys (like arrow keys).
# --------------------------------------------------------------------------------

read_key () {

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
            "[H") echo "home" ;;
            "[F") echo "end" ;;
            "[5~") echo "page_up" ;;
            "[6~") echo "page_down" ;;
            "[2~") echo "insert" ;;
            "[3~") echo "delete" ;;
            "[Z") echo "shift_tab" ;;
            "OP") echo "f1" ;;
            "OQ") echo "f2" ;;
            "OR") echo "f3" ;;
            "OS") echo "f4" ;;
            "[15~") echo "f5" ;;
            "[17~") echo "f6" ;;
            "[18~") echo "f7" ;;
            "[19~") echo "f8" ;;
            "[20~") echo "f9" ;;
            "[21~") echo "f10" ;;
            "[23~") echo "f11" ;;
            "[24~") echo "f12" ;;
            *) echo "escape" ;;
        esac

    else

        # Handle regular keys, convert control keys to readable names
        case "$key" in
            $'\t') echo "tab" ;;
            $'\n') echo "enter" ;;
            $'\b') echo "backspace" ;;
            $' ') echo "space" ;;
            [[:cntrl:]]) printf "ctrl_%s" "$(echo "$key" | tr -d '\0-\31')" ;;
            *) echo "$key" ;;  # Regular character
        esac

    fi

}
