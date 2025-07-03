#!/bin/bash

help () {

    clear_content

    print_actions "[TAB] Search Help"

    print_title "WELCOME TO FILECOMP"

    jump_content

    local help=(
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
    )

    for i in "${!help[@]}"; do printf "%s%s\n" "$PRFX" "${help[i]}"; done

}