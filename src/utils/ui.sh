#!/bin/bash

export COLS=$( tput cols )
export ROWS=$( tput lines )

export LGAP=2
export WIDTH=$(( $COLS - ( $LGAP * 2 ) ))
export PRFX=$( printf '%*s' $LGAP )

export START=4
export END=$(( $ROWS - 6 ))
export HEIGHT=$(( $ROWS - 10 ))

setup_env () {

    ENV_STTY=$( stty -g )

    trap 'reset_env' INT TERM EXIT

    stty -icanon -echo min 1 time 0
    clear; tput civis

}

reset_env () {

    stty "$ENV_STTY"
    tput cnorm

    clear; exit 0

}

quit () {
    reset_env
}

jump_content () {
    tput cup $START 0
}

set_line () {
    tput cup $1 0; tput el
}

clear_content () {
    for (( i=START; i < END; i++ )); do set_line $i; done
    jump_content
}

repeat_char () {
    for (( i=0; i < $2; i++ )); do printf "%s" "$1"; done
}

print_header () {



}

print_footer () {



}
