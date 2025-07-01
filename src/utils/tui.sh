#!/bin/bash

source ./colors.sh

# Terminal dimensions
COLS=$( tput cols )
ROWS=$( tput lines )

print_actions () {

    local row=$(( ROWS - 3 ))
    tput cup $row 0

    local i=1
    while [[ $i -lt $# ]]; do

        local text="${!i}"
        local next=$(( i + 1 ))
        local color="${!next}"

        if [[ $color =~ ^[0-9]+$ ]]; then
            color_output "$text" 7 $color
            i=$(( i + 2 ))
        else
            printf "%s" "$text"
            i=$(( i + 1 ))
        fi

        printf "   "

    done

    echo

}