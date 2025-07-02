#!/bin/bash

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