#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/ui.sh"

# Global variable to store the key pressed
KEY=0

# Internal: Parse raw key input and set KEY variable
# This function captures single key presses, including escape sequences for special keys.
# It sets the global variable KEY to a readable name for the key pressed.
# If no of the specified keys are pressed, KEY will be set to 0.
parse_key () {

    local key="$1"

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
            $'\b'|$'\x7f' )  KEY="back" ;;
            * )              KEY=0
        esac

    fi

}

# Internal: Clear the input buffer
# Reading and discarding all characters within a very short timeout
clear_buffer () {
    while IFS= read -rsn1 -t 0.001 _; do :; done
}

# Blocking: Wait for a key press and parse it
read_key () {

    local key

    # Read raw terminal input
    IFS= read -rsn1 key 2>/dev/null || return

    # Parse terminal input
    parse_key "$key"

    # Clear the input buffer
    clear_buffer

}

# Non-blocking: Only parse key if available, else KEY=0
read_key_nonblock () {

    local key

    # Check for raw terminal input
    if IFS= read -rsn1 -t 0.001 key 2>/dev/null; then

        # Parse terminal input
        parse_key "$key"

        # Clear the input buffer
        clear_buffer

    else KEY=0; fi

}

# Reset the environment and exit the script
quit () {
    reset_env
}

# Check if the user wants to quit
may_quit () {

    # Read key input non-blocking
    KEY=0; read_key_nonblock

    # If the quit key is pressed, exit the script
    if [[ "$KEY" == "quit" ]]; then quit; fi

}

# Wait for the user to press enter to proceed or quit the script
await_to_proceed () {

    KEY=0

    while true; do

        # Read key input
        read_key

        # If the user pressed enter, break the loop
        # If the user pressed quit, exit the script
        case "$KEY" in
            "enter" ) break ;;
            "quit" )  quit ;;
        esac

    done

}
