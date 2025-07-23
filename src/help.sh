#!/bin/bash

# Load utility scripts
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/ui.sh"
source "$SCRIPT_DIR/utils/ctrl.sh"

# Help screen for FileComp
print_help () {

    local tab=0 prev=-1 max=3 help=()

    # Print actions
    print_actions "TAB::Page" "ENTER::Proceed" "Q::Quit"

    # Print the title
    print_title "WELCOME TO FILECOMP"

    # Main loop
    while true; do

        # Render only if the tab has changed
        if (( prev != tab )); then

            case $tab in

                # Overview / Intro
                0 ) help=(
                    "FileComp recursively compares two directories for unique files using their hash values."
                    "To accomplish this, the program runs through a series of steps."
                    ""
                    "${BOLD}Steps:${RESET}"
                    "1) Select base directory."
                    "2) Select directory to compare."
                    "3) Choose hash algorithm (e.g., SHA1)."
                    "4) Choose number of threads to run on."
                    "5) Choose output: log, copy, or both."
                    "6) (Optional) Select folder to copy unique files."
                    "7) Decide whether to keep or delete hash DB."
                    ""
                    "Use ${BOLD}arrow keys${RESET} and ${BOLD}Enter${RESET} to navigate menus."
                    "Press ${BOLD}Q${RESET} anytime to quit."
                ) ;;

                # Functions
                1 ) help=(
                    "FileComp operates carefully with your files and will neither change nor move them."
                    ""
                    "${BOLD}Hashing:${RESET}"
                    "It calculates hashes for files to detect unique ones, rather than looking for names."
                    "Therefore you can choose from different hashing algorithms (e.g. SHA1, MD5, B2)."
                    ""
                    "${BOLD}Comparison:${RESET}"
                    "Choose source and target directories for comparison through arrow key navigation."
                    "Files from target will be compared with those from base and treated as unique."
                    ""
                    "${BOLD}Database:${RESET}"
                    "The program will create a database of file hashes to speed up the process."
                    "This database will remain in your working directory unless you delete it."
                    ""
                    "${BOLD}Copying:${RESET}"
                    "Beside of logging unique files, FileComp can copies them to a chosen directory."
                    "The original files are kept safe."
                ) ;;

                # Functions
                2 ) help=(
                    "Users are guided safely through the individual steps, no text input is necessary."
                    ""
                    "${BOLD}Navigation:${RESET}"
                    "The controls work intuitively and do not require any direct text input."
                    "Available commands are listed below, at the bottom of the screen."
                    ""
                    "${BOLD}Select Directories:${RESET}"
                    "Directories are selected using lists that can be navigated through the arrow keys."
                    "The program can search the entire tree, starting from the home folder."
                    ""
                    "${BOLD}Hash Algorithm:${RESET}"
                    "FileComp works with various hash algorithms that are installed on your machine."
                    "Choose between: ${BOLD}${CYAN}${AVAILABLE_HASHES[*]}${RESET}"
                    ""
                    "${BOLD}Output Mode:${RESET}"
                    "By default, the list of unique files will be recorded within a log."
                    "The second method is to copy the files to a new folder."
                ) ;;

            esac

            # Clear the screen
            clear_content

            # Print the help content line by line
            for i in "${!help[@]}"; do printf "%s%s\n" "$PRFX" "${help[$i]}"; done

            # Set previous tab to current
            prev=$tab

        fi

        # Read key input
        read_key

        # Check for commands
        case "$KEY" in
            "tab" )   tab=$(( ( $tab + 1 ) % $max )) ;;
            "enter" ) break ;;
            "quit" )  quit ;;
        esac

    done

}
