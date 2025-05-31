#!/bin/bash

# Get the directory of the current script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Source helper file
source $SCRIPT_DIR/helper.sh

# Trap for unexpected exits
trap 'trap_message' INT TERM

# Script start
log_message "Installation started"
print_bold_blue "\nSimple Hyprland"
echo "---------------"

# Check if OS is Arch Linux
check_os

# Run child scripts
run_script "allinone.sh" "All in One Setup"

print_bold_blue "\n🌟 Setup Complete\n"
log_message "Installation completed successfully"
