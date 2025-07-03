#!/bin/bash

source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/ui.sh"
source "$SCRIPT_DIR/utils/ctrl.sh"

print_help () {

    local tab=0 prev=-1 max=3 help=()

    print_actions "TAB::Help"

    print_title "WELCOME TO FILECOMP"

    while true; do

        if (( prev != tab )); then

            case $tab in

                # Overview / Intro
                0 ) help=(
                    "FileComp recursively compares two directories for unique files using their hash values."
                    ""
                    "${BOLD}Steps:${RESET}"
                    "1) Select base directory."
                    "2) Select directory to compare."
                    "3) Choose hash algorithm (e.g., SHA1)."
                    "4) Choose output: log, copy, or both."
                    "5) (Optional) Select folder to copy unique files."
                    "6) Decide whether to keep or delete hash DB."
                    ""
                    "Use ${BOLD}arrow keys${RESET} and ${BOLD}Enter${RESET} to navigate menus."
                    "Press ${BOLD}Q${RESET} anytime to quit."
                ) ;;

                # Functions
                1 ) help=(
                    "${BOLD}Functions:${RESET}"
                    ""
                    "${BOLD}Directories:${RESET} Choose source and target directories for comparison."
                    "${BOLD}Hashing:${RESET} Calculates hashes for all files to detect unique files."
                    "${BOLD}Logging:${RESET} Outputs a log of unique files."
                    "${BOLD}Copying:${RESET} Optionally copies unique files to a chosen directory."
                    "${BOLD}Database:${RESET} Build a hash database for comparison."
                ) ;;

                # Functions
                2 ) help=(
                    "${BOLD}Settings:${RESET}"
                    ""
                    "${BOLD}Hash Algorithm:${RESET} Choose between SHA1, SHA256, MD5 and B2SUM"
                    "${BOLD}Output Mode:${RESET} Write to log, copy files, or both options."
                    "${BOLD}Copy Directory:${RESET} Set a folder for unique files."
                    "${BOLD}Database Handling:${RESET} Decide to keep or delete hash DB after run."
                    "${BOLD}Navigation:${RESET} Simple navigation using arrow keys."
                ) ;;

            esac

            clear_content

            for i in "${!help[@]}"; do printf "%s%s\n" "$PRFX" "${help[$i]}"; done

            prev=$tab

        fi

        read_key

        case "$KEY" in
            "tab" ) tab=$(( ( $tab + 1 ) % $max )) ;;
            "enter" ) break ;;
            "quit" )  quit ;;
        esac

    done

}
