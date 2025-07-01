#!/bin/bash

# --------------------------------------------------------------------------------
# src/utils/folder.sh
#
# Directory navigator with arrow key control, similar to Midnight Commander:
# -> up/down = navigation
# -> right = in, left = back
# -> Enter selects folder
# --------------------------------------------------------------------------------

source ./src/utils/tui.sh

select_folder() {

    local lbeg=$(( START + 2 ))
    local lend=END
    local current_path="$1"
    local entries

    local pointer=0
    local key

    print_title "SELECT FOLDER"

    # The main loop
    # Show list of directories
    while true; do

        # Inhalt des Ordners einlesen (nur Verzeichnisse)
        mapfile -t entries < <(find "$current_path" -mindepth 1 -maxdepth 1 -type d | sort)
        local visible_count=$(( lend - lbeg ))

        # Startposition der Anzeige berechnen (für Scroll-Effekt)
        local offset=0
        (( pointer >= visible_count )) && offset=$(( pointer - visible_count + 1 ))

        # Sichtbare Einträge anzeigen
        for (( i=0; i < visible_count; i++ )); do

            local index=$(( i + offset ))
            local line=$(( lbeg + i ))

            [[ $index -ge ${#entries[@]} ]] && break

            local name="$(basename "${entries[$index]}")"

            tput cup $line 0
            tput el

            if (( index == pointer )); then
                tput rev  # Reverse video
                printf " > %s" "$name"
                tput sgr0
            else
                printf "   %s" "$name"
            fi
        done

        print_actions "[⇕] Move" "[⇔] Navigate" "[↵] Confirm" 2 "[Q] Quit"

        # Eingabe lesen
        IFS= read -rsn1 key
        if [[ $key == $'\x1b' ]]; then
            read -rsn2 rest
            key+="$rest"
        fi

        case "$key" in
            $'\x1b[A')  # Hoch
                (( pointer > 0 )) && ((pointer--))
                ;;
            $'\x1b[B')  # Runter
                (( pointer < ${#entries[@]} - 1 )) && ((pointer++))
                ;;
            $'\x1b[C')  # Rechts (tiefer)
                current_path="${entries[$pointer]}"
                pointer=0
                ;;
            $'\x1b[D')  # Links (zurück)
                current_path="$(dirname "$current_path")"
                pointer=0
                ;;
            "")  # Enter
                echo "$current_path"
                return 0
                ;;
            [qQ])
                clear
                exit 1
                ;;
        esac
    done

}