#!/bin/bash

# --------------------------------------------------------------------------------
# src/utils/colors.sh
# Colors
#
# This script provides functions to manage terminal colors and styles.
# It defines color variables and functions to set and reset colors for
# terminal output. It is used to enhance the visual output of the
# terminal user interface (TUI).
# --------------------------------------------------------------------------------

# General commands
export RESET="$( tput sgr0)"
export REV="$( tput rev)"

# Foreground colors
export BLACK="$( tput setaf 0 )"
export RED="$( tput setaf 1 )"
export GREEN="$( tput setaf 2 )"
export YELLOW="$( tput setaf 3 )"
export BLUE="$( tput setaf 4 )"
export MAGENTA="$( tput setaf 5 )"
export CYAN="$( tput setaf 6 )"
export WHITE="$( tput setaf 7 )"

# Background colors
export BG_BLACK="$( tput setab 0 )"
export BG_RED="$( tput setab 1 )"
export BG_GREEN="$( tput setab 2 )"
export BG_YELLOW="$( tput setab 3 )"
export BG_BLUE="$( tput setab 4 )"
export BG_MAGENTA="$( tput setab 5 )"
export BG_CYAN="$( tput setab 6 )"
export BG_WHITE="$( tput setab 7 )"

# Styles
export S_ULINE="$( tput smul )"
export R_ULINE="$( tput rmul )"
export S_SOLID="$( tput smso )"
export R_SOLID="$( tput rmso )"
export BOLD="$( tput bold )"

# Reset terminal colors and styles
reset_color () {
    tput sgr0
}

# Set foreground color
set_color () {
    tput setaf $1
}

# Set background color
set_bgcol () {
    tput setab $1
}

# Print colored output
# Usage: color_output "text" "color" "bgcolor"
# $1 - The text to print
# $2 - The foreground color (0-7 for standard colors)
# $3 - The background color (0-7 for standard colors)
color_output () {

    local text="$1"
    local color="$2"
    local bgcol="$3"

    if [[ $color =~ ^[0-9]+$ ]]; then
      set_color $color
    fi

    if [[ $bgcol =~ ^[0-9]+$ ]]; then
      set_bgcol $bgcol
    fi

    printf "%s" "$text"
    reset_color

}
