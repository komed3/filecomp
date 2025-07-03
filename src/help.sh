#!/bin/bash

HTAB=0

help () {

    print_actions "[TAB] Search Help"

    print_title "WELCOME TO FILECOMP"

    clear_content

    if [[ $PREV != 0 ]]; then
        HTAB=0
    elif [[ $KEY == "tab" ]]; then
        HTAB=$(( ( $HTAB + 1 ) % 3 ))
    fi

    local help=()

    case $HTAB in

        # Overview
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
            "${BOLD}Directory Selection:${RESET} Choose source and target directories for comparison."
            "${BOLD}Hashing:${RESET} Calculates hashes for all files to detect unique files."
            "${BOLD}Logging:${RESET} Outputs a log of unique files."
            "${BOLD}Copying:${RESET} Copies unique files to a chosen directory."
            "${BOLD}Database:${RESET} Generating a hash database for comparison."
        ) ;;

        # Settings
        2 ) help=(
            "${BOLD}Settings:${RESET}"
            ""
            "${BOLD}Hash Algorithm:${RESET} Choose between SHA1, SHA256, MD5 and B2SUM."
            "${BOLD}Output Mode:${RESET} Select log, copy, or both."
            "${BOLD}Copy Directory:${RESET} Set a folder for unique files."
            "${BOLD}Database Handling:${RESET} Decide to keep or delete hash DB after run."
            "${BOLD}Navigation:${RESET} Use arrow keys, Enter, Tab, Q and others."
        ) ;;

    esac

    for i in "${!help[@]}"; do printf "%s%s\n" "$PRFX" "${help[i]}"; done

}