#!/bin/bash

source ./src/utils/colors.sh

# Terminal dimensions
export COLS=$( tput cols )
export ROWS=$( tput lines )
export PRFX="   "

# Change terminal output and clears it
# Hide cursor, clean up on abort
clear_screen () {

    tput civis
    clear

    trap "tput cnorm; clear; exit" SIGINT SIGTERM

}

# Creates the program header and clears the terminal
print_header () {

    local left=$(( ( COLS - 10 ) / 2 ))
    local right=$(( COLS - left - 10 ))

    clear_screen

    tput cup 0 0
    set_bgcol 7
    printf '%*s' "$left" ""
    reset_color
    printf " FILECOMP "
    set_bgcol 7
    printf '%*s' "$right" ""
    reset_color
    echo

}

# Helper: Display action line
# Transfer two values per action
# (1) text
# (2) optional color (e.g. 4 for blue)
print_actions () {

    local row=$(( ROWS - 4 ))
    tput cup $row 0

    local i=1
    while [[ $i -lt $# ]]; do

        local text="${!i}"
        local next=$(( i + 1 ))
        local color="${!next}"

        printf "%s" "$PRFX"

        if [[ $color =~ ^[0-9]+$ ]]; then
            color_output "$text" $color
            i=$(( i + 2 ))
        else
            printf "%s" "$text"
            i=$(( i + 1 ))
        fi

    done

    echo

}