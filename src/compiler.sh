#!/bin/bash

# Define color codes for output messages
YELLOW="\033[1;33m"
RED="\033[0;91m"
GREEN="\033[1;32m"
BLUE="\033[0;94m"
MAGENTA="\033[0;95m"
RESET="\033[0m"

# Functions to ask yes/no and c/cpp questions
ask_yes_no() {
	local prompt="$1"
	while true; do
		read -p "$prompt (y/n) " answer || { echo -e "${RED}Failed to read input.${RESET}"; return 2; }
		case "$answer" in
			y|Y) return 0 ;;
			n|N) return 1 ;;
			*) echo -e "${YELLOW}Invalid input. Please enter 'y' or 'n'.${RESET}" ;;
		esac
	done
}

ask_c_cpp() {
	local prompt="$1"
	while true; do
		read -p "$prompt (c/cpp) " answer || { echo -e "${RED}Failed to read input.${RESET}"; return 2; }
		case "$answer" in
			c|C) return 0 ;;
			cpp|CPP) return 1 ;;
			*) echo -e "${YELLOW}Invalid input. Please enter 'c' or 'cpp'.${RESET}" ;;
		esac
	done
}

# Check if required scripts exist
SCRIPT_DIR="$HOME/.script/src"
if [[ ! -f "$SCRIPT_DIR/cMakefile.sh" ]]; then
	echo -e "${RED}Error: cMakefile.sh not found in $SCRIPT_DIR${RESET}"
	exit 1
fi
if [[ ! -f "$SCRIPT_DIR/cppMakefile.sh" ]]; then
	echo -e "${RED}Error: cppMakefile.sh not found in $SCRIPT_DIR${RESET}"
	exit 1
fi

# Main script execution starts here
if ask_yes_no "Do you need C or C++ Makefile"; then
	if ask_c_cpp "Which one do you need?"; then
		bash "$SCRIPT_DIR/cMakefile.sh" || { echo -e "${RED}Failed to create C Makefile.${RESET}"; exit 1; }
	else
		bash "$SCRIPT_DIR/cppMakefile.sh" || { echo -e "${RED}Failed to create C++ Makefile.${RESET}"; exit 1; }
	fi
else
	echo -e "${BLUE}Does not require a C or C++ Makefile.${RESET}"
fi
