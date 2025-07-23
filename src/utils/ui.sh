#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/colors.sh"

# Terminal dimensions
COLS=$( tput cols )
ROWS=$( tput lines )

LGAP=2
WIDTH=$(( $COLS - ( $LGAP * 2 ) ))
PRFX=$( printf '%*s' $LGAP )

START=4
END=$(( $ROWS - 6 ))
HEIGHT=$(( $ROWS - 10 ))

# Jump to the content area
jump_content () {
    tput cup $START 0
}

# Set the cursor to a specific line and column, clearing the line
set_line () {
    tput cup $1 0; tput el; tput cup $1 ${2:-$LGAP}
}

# Clear the content area and reset the cursor position
clear_content () {
    for (( i=START; i < END; i++ )); do set_line $i; done
    jump_content
}

# Print a character multiple times
repeat_char () {
    for (( i=0; i < $2; i++ )); do printf "%s" "$1"; done
}

# Print the program header
print_header () {

    local left=$(( ( $COLS - 10 ) / 2 ))
    local right=$(( $COLS - $left - 10 ))

    set_line 0 0
    printf "%s%*s%s" "$REVID" "$left" "" "$RESET"
    printf " FILECOMP "
    printf "%s%*s%s" "$REVID" "$right" "" "$RESET"

}

# Print the program footer with credits
print_footer () {

    local credits="(c) 2025 [MIT] Paul Köhler (komed3) — FILECOME v0.1.0"
    local left=$(( $COLS - ${#credits} ))

    set_line $(( $ROWS - 1 )) 0
    printf "%s%*s%s%s" "$REVID" "$left" "" "$credits" "$RESET"

}

# Print the (current step) title
print_title () {
    set_line 2
    printf "%s%s%s\n" "$SLINE" "$1" "$RLINE"
}

# Print the actions at the bottom of the screen
# The actions are passed as arguments, with "ENTER" and "Q" always included
print_actions () {

    local actions=( "$@" )

    set_line $(( $ROWS - 3 ))

    for action in "${actions[@]}"; do
        printf "%s %s %s  " "$REVID" "$action" "$RESET"
    done

}

# Clear all actions at the bottom of the screen
clear_actions () {
    set_line $(( $ROWS - 3 ))
}
