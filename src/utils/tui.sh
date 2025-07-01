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
export PRFX="  "

# Change terminal output and clears it
# Hide cursor, clean up on abort
clear_screen () {

    tput civis
    clear

    trap "tput cnorm; clear; exit" SIGINT SIGTERM

}

# Program header
# Displays the header and clears the terminal
print_header () {

    local left=$(( ( COLS - 10 ) / 2 ))
    local right=$(( COLS - left - 10 ))

    clear_screen

    tput cup 0 0
    set_bgcol 7
    printf "%*s" "$left" ""
    reset_color
    printf " FILECOMP "
    set_bgcol 7
    printf "%*s" "$right" ""
    reset_color
    tput cup 2 0

}

# Program footer
# Displays some information such as name, version, author, etc.
print_footer () {

    local row=$(( ROWS - 1 ))
    tput cup $row 0

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
    local title="$1"
    echo "$PRFX$S_ULINE$title$R_ULINE"; echo
}

# Helper: Display action line
# Transfer two values per action
# (1) text
# (2) optional color (e.g. 4 for blue)
print_actions () {

    local row=$(( ROWS - 4 ))
    tput cup $row 0

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