#!/bin/bash

set -euo pipefail

# Define color codes for output messages
YELLOW="\033[1;33m"
RED="\033[0;91m"
GREEN="\033[1;32m"
BLUE="\033[0;94m"
MAGENTA="\033[0;95m"
RESET="\033[0m"

# Functions to ask yes/no questions
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

SCRIPT_DIR="$HOME/.script/src"
if [[ ! -f "$SCRIPT_DIR/libft.sh" ]]; then
	echo -e "${RED}Error: libft.sh not found in $SCRIPT_DIR${RESET}"
	exit 1
fi
if [[ ! -f "$SCRIPT_DIR/compiler.sh" ]]; then
	echo -e "${RED}Error: compiler.sh not found in $SCRIPT_DIR${RESET}"
	exit 1
fi
if [[ ! -f "$SCRIPT_DIR/gitignore.sh" ]]; then
	echo -e "${RED}Error: gitignore.sh not found in $SCRIPT_DIR${RESET}"
	exit 1
fi

# Define variables
PWD_DIR="$(pwd)"

echo -e "${YELLOW}Creating new Project...${RESET}"

read -p "Project name: " PROJECT_NAME || { echo -e "${RED}Failed to read input.${RESET}"; exit 1; }
while [[ -z "${PROJECT_NAME// }" ]]; do
	echo -e "${YELLOW}The project name cannot be empty.${RESET}"
	read -p "Project name: " PROJECT_NAME || { echo -e "${RED}Failed to read input.${RESET}"; exit 1; }
done

if [[ -d "$PWD_DIR/$PROJECT_NAME" ]]; then
	echo -e "${RED}Directory '$PROJECT_NAME' already exists in $(pwd).${RESET}"
	exit 1
fi

read -p "Git repository: " GIT_REPO || { echo -e "${RED}Failed to read input.${RESET}"; exit 1; }
while [[ -z "${GIT_REPO// }" ]]; do
	echo -e "${YELLOW}The Git repository cannot be empty.${RESET}"
	read -p "Git repository: " GIT_REPO || { echo -e "${RED}Failed to read input.${RESET}"; exit 1; }
done

echo -e "${YELLOW}Cloning Repository...${RESET}"
git clone --recursive "$GIT_REPO" "$PWD_DIR/$PROJECT_NAME" > /dev/null 2>&1 || { echo -e "${RED}Failed to clone the repository.${RESET}"; exit 1; }
echo -e "${GREEN}Project '$PROJECT_NAME' created successfully.${RESET}"

cd "$PWD_DIR/$PROJECT_NAME" || { echo -e "${RED}Failed to change directory to the new project.${RESET}"; exit 1; }

bash "$SCRIPT_DIR/gitignore.sh" || { echo -e "${RED}Failed to create .gitignore.${RESET}"; exit 1; }

bash "$SCRIPT_DIR/compiler.sh" || { echo -e "${RED}Failed to set up compiler.${RESET}"; exit 1; }

if ask_yes_no "Do you want to create a src folder structure?"; then
	mkdir -p src
	echo -e "${GREEN}src folder created.${RESET}"
fi

if ask_yes_no "Do you want to initialize a libft in this project?"; then
	bash "$SCRIPT_DIR/libft.sh" || { echo -e "${RED}Failed to initialize libft.${RESET}"; exit 1; }
fi

echo -e "${GREEN}New project setup completed successfully.${RESET}"
