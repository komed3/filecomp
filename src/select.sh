#!/bin/bash

# ------------------------------------------------
# select.sh
# Interactive terminal menu (radio & checkbox)
#
# Function: select_menu
# Parameters:
# $1 - Title (String)
# $2 - Type: 'multi=0' (radio) or 'multi=1' (checklist)
# $3 - require_one: '1' = at least one selection required, '0' = optional
# $4 - allow_none: '1' = deselection to zero allowed, '0' = at least one selection for radio
# $5 - Array name of the options (without @)
# $6 - Array name of initial states (without @)
# Return:
# Array 'result' contains the selected indices
# ------------------------------------------------

select_menu() {

    local title="$1"
    local multi_flag="$2"      # 0 = Radio (single), 1 = Checkbox (multi)
    local require_one="$3"     # 1 = at least one selection required
    local allow_none="$4"      # 1 = no choice allowed, 0 = at least one for radio
    local opts_name="$5"       # Array name of the options
    local init_name="$6"       # Array name of initial states



}