#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/ui.sh"

# Global variable to store the key pressed
KEY=""

# Function to read a key from the terminal
# This function captures single key presses, including escape sequences for special keys.
# It sets the global variable KEY to a readable name for the key pressed.
# If no of the specified keys are pressed, KEY will be set to 0.
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
            $'\b' )          KEY="back" ;;
            * )              KEY=0
        esac

    fi

    # Catch all following inputs (e.g. if the button is held down)
    while IFS= read -rsn1 -t 0.001 _; do :; done

}

# Reset the environment and exit the script
quit () {
    reset_env
}

# Wait for the user to press enter to proceed or quit the script
await_to_proceed () {

    while true; do

        read_key

        case "$KEY" in
            "enter" ) break ;;
            "quit" )  quit ;;
        esac

    done

}
