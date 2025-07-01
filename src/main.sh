#!/bin/bash

source ./src/utils/tui.sh

main () {

    # Clear and setup screen
    clear; setup_screen

    # Print the program header
    print_header

    # Print the program footer
    print_footer

}

main