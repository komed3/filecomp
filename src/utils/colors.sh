#!/bin/bash

export   BLACK="$(tput setaf 0)"
export     RED="$(tput setaf 1)"
export   GREEN="$(tput setaf 2)"
export  YELLOW="$(tput setaf 3)"
export    BLUE="$(tput setaf 4)"
export MAGENTA="$(tput setaf 5)"
export    CYAN="$(tput setaf 6)"
export   WHITE="$(tput setaf 7)"

export   BG_BLACK="$(tput setab 0)"
export     BG_RED="$(tput setab 1)"
export   BG_GREEN="$(tput setab 2)"
export  BG_YELLOW="$(tput setab 3)"
export    BG_BLUE="$(tput setab 4)"
export BG_MAGENTA="$(tput setab 5)"
export    BG_CYAN="$(tput setab 6)"
export   BG_WHITE="$(tput setab 7)"

reset_color () {
    tput sgr0
}

set_color () {
    local color="$1"
    tput setaf $color
}

set_bgcol () {
    local color="$1"
    tput setab $color
}

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

    echo $text
    reset_color

}