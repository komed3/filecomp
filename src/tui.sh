#!/bin/bash

screen_init() {
    tput clear
    tput civis
}

screen_clear() {
    tput cnorm
    tput srg0
    clear
}