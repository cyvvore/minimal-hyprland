#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# Print helpers
print_error()   { echo -e "${RED}$1${NC}"; }
print_success() { echo -e "${GREEN}$1${NC}"; }
print_warning() { echo -e "${YELLOW}$1${NC}"; }
print_info()    { echo -e "${BLUE}$1${NC}"; }

# Paths
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOG_FILE="$SCRIPT_DIR/simple_hyprland_install.log"

# Logging
log_message() {
    echo "$(date): $1" >> "$LOG_FILE"
}

# Trap interrupts
trap_message() {
    print_error "\n\nScript interrupted. Exiting.....\n"
    log_message "Script interrupted and exited"
    exit 1
}

# Run command
run_command() {
    local cmd="$1"
    local description="$2"
    echo -e "${BLUE}\n==> ${description}${NC}"
    log_message "Running: $cmd"
    sleep 5
    if eval "$cmd"; then
        print_success "$description completed successfully."
        log_message "$description succeeded"
    else
        print_error "$description failed."
        log_message "$description failed"
    fi
}

