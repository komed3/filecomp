#!/bin/bash

# Max. colums
MAX_COLS=$( tput cols )
MAX_ROWS=$( tput lines )

# Init the screen for filecomp
screen_init() {
    tput clear
    tput civis
}

# Bring the screen back to normal
screen_clear() {
    tput cnorm
    tput srg0
    clear
}

header() {
    tput cup 0 0
    printf "FILECOMP"
}

footer() {

}