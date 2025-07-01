#!/bin/bash

# --------------------------------------------------------------------------------
# src/utils/tui.sh
# Terminal UI
#
# This script provides functions to manage the terminal UI, including printing
# headers, footers, handling actions, and managing terminal output.
# --------------------------------------------------------------------------------

source ./src/utils/colors.sh

# Terminal dimensions
export COLS=$( tput cols )
export ROWS=$( tput lines )
export START=2
export END=$(( ROWS - 7 ))
export PRFX="  "
export LGAP=2

# Change terminal output and clears it
# Hide cursor, clean up on abort
setup_screen () {

    trap "tput cnorm; clear; exit" SIGINT SIGTERM
    tput civis

}

# Quit the program safely
quit () {
    tput cnorm; clear; exit 1
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
    printf "%s%s%s%s\n" "$PRFX" "${S_ULINE}" "$1" "${R_ULINE}"; echo
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
