#!/bin/bash

# --------------------------------------------------------------------------------
# src/utils/tui.sh
# Terminal UI
#
# This script provides functions to manage the terminal UI, including printing
# headers, footers, handling actions, and managing terminal output.
# --------------------------------------------------------------------------------

source "$SCRIPT_DIR/utils/colors.sh"

# Terminal dimensions
export COLS=$( tput cols )
export ROWS=$( tput lines )
export START=2
export END=$(( ROWS - 7 ))
export PRFX="  "
export LGAP=2

# Setup the terminal for TUI
# Configures the terminal for a text-based user interface (TUI).
# Disables canonical mode and echo, hides the cursor, and sets up
# a trap to reset the terminal on exit or interruption.
setup_screen () {

    STTY=$( stty -g )

    trap 'reset_screen' INT TERM EXIT

    stty -icanon -echo min 1 time 0
    tput civis

}

# Reset the terminal to its original state
reset_screen () {

    stty "$STTY"
    tput cnorm
    
    clear; exit 0

}

# Quit the program safely
quit () {
    reset_screen
}

# Helper to jump to the right cell for content
jump_content () {
    tput cup $START 0
}

set_line () {
    tput cup $1 0; tput el
}

# Helper function to clear content
clear_content () {
    for (( i=START; i < END; i++ )); do set_line $i; done
    jump_content
}

# Repeat a character multiple times
# $1 - Character to repeat
# $2 - Number of times to repeat
repeat_char () {
    for (( i=0; i < $2; i++ )); do printf "%s" "$1"; done
}

# Program header
# Displays the header with the program name
print_header () {

    local left=$(( ( COLS - 10 ) / 2 ))
    local right=$(( COLS - left - 10 ))

    set_line 0
    set_bgcol 7
    printf "%*s" "$left" ""
    reset_color
    printf " FILECOMP "
    set_bgcol 7
    printf "%*s" "$right" ""
    reset_color

}

# Program footer
# Displays some information such as name, version, author, etc.
print_footer () {

    set_line $(( ROWS - 1 ))

    local credits="(c) 2025 [MIT] Paul Köhler (komed3) — FILECOME v0.1.0"
    local len=${#credits}
    local left=$(( COLS - len - 1 ))

    set_color 0
    set_bgcol 7
    printf "%*s" "$left" ""
    printf "%s" " $credits"
    reset_color

}

# Print a (underlined) title line
print_title () {
    printf "%s%s%s%s\n" "$PRFX" "$S_ULINE" "$1" "$R_ULINE"; echo
}

# Helper: Display action line
# Transfer two values per action
# (1) text
# (2) optional color (e.g. 4 for blue)
print_actions () {

    set_line $(( ROWS - 3 ))

    # List all options
    for (( i=1; i <= $#; i++ )); do

        local text="${!i}"
        local j=$(( i + 1 ))
        local color="${!j}"

        printf "%s" "$PRFX"

        # Print option with color if specified
        if [[ $color =~ ^[0-9]+$ ]]; then
            color_output "$text" $color
            (( i++ ))
        else
            printf "%s" "$text"
        fi

    done

    echo

}
