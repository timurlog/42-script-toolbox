#!/bin/bash

set -euo pipefail

# Define color codes for output messages
YELLOW="\033[1;33m"
RED="\033[0;91m"
GREEN="\033[1;32m"
BLUE="\033[0;94m"
MAGENTA="\033[0;95m"
RESET="\033[0m"

# Define variables for repository URL, temporary directory, installation directory, and shell configuration file
REPO_URL="https://github.com/timurlog/best_script.git"
INSTALL_DIR="$HOME/.script"
HOME_DIR="$HOME"
PWD_DIR="$(pwd)"
RC_FILE="$HOME/.zshrc"

# Display a welcome message
echo -e "${BLUE}Welcome to the Best Script installer.${RESET}"

# Navigate to the home directory
cd "$HOME" || { echo -e "${RED}Unable to return to the home directory.${RESET}"; exit 1; }

# Prepare for installation by creating a temporary directory
echo -e "${YELLOW}Preparing the installation...${RESET}"
TEMP_DIR="$(mktemp -d)" || { echo -e "${RED}Failed to create the temporary directory.${RESET}"; exit 1; }

# Ensure the temporary directory is removed on script exit
trap 'rm -rf "$TEMP_DIR"' EXIT

# Clone the repository into the temporary directory
echo -e "${YELLOW}Cloning the repository...${RESET}"
git clone --recursive "$REPO_URL" "$TEMP_DIR/.script" > /dev/null 2>&1 || { echo -e "${RED}Failed to clone the repository.${RESET}"; exit 1; }

# Copy the cloned files to the installation directory
echo -e "${YELLOW}Copying files...${RESET}"
rm -rf "$INSTALL_DIR"
cp -r "$TEMP_DIR/.script" "$HOME_DIR" || { echo -e "${RED}Failed to copy files.${RESET}"; exit 1; }

# # Add an alias to the shell configuration file if it doesn't already exist
echo -e "${YELLOW}Adding alias and export in ${MAGENTA}$RC_FILE${YELLOW}...${RESET}"
if ! grep -q "alias npro=" "$RC_FILE"; then
	printf "\nalias npro=%s/.script/src/newProject.sh" "$HOME_DIR" >> "$RC_FILE"
fi
if ! grep -q "alias alibft=" "$RC_FILE"; then
	printf "\nalias alibft=%s/.script/src/libft.sh" "$HOME_DIR" >> "$RC_FILE"
fi
if ! grep -q "alias acomp=" "$RC_FILE"; then
	printf "\nalias acomp=%s/.script/src/compiler.sh" "$HOME_DIR" >> "$RC_FILE"
fi
if ! grep -q "alias agit=" "$RC_FILE"; then
	printf "\nalias agit=%s/.script/src/gitignore.sh" "$HOME_DIR" >> "$RC_FILE"
fi
if ! grep -q "alias ulibft=" "$RC_FILE"; then
	printf "\nalias ulibft=%s/.script/src/updateLibft.sh" "$HOME_DIR" >> "$RC_FILE"
fi
read -rp "42 Username: " USER || { echo -e "${RED}Failed to read input.${RESET}"; exit 1; }
while [[ -z "${USER// }" ]]; do
	echo -e "${YELLOW}The username cannot be empty.${RESET}"
	read -rp "42 Username: " USER || { echo -e "${RED}Failed to read input.${RESET}"; exit 1; }
done
if grep -q "^USER=" "$RC_FILE"; then
	sed -i "s|^USER=.*|USER=$USER|" "$RC_FILE"
else
	printf "\nUSER=%s" "$USER" >> "$RC_FILE"
fi
read -rp "42 Mail: " MAIL || { echo -e "${RED}Failed to read input.${RESET}"; exit 1; }
while [[ -z "${MAIL// }" ]]; do
	echo -e "${YELLOW}The mail cannot be empty.${RESET}"
	read -rp "42 Mail: " MAIL || { echo -e "${RED}Failed to read input.${RESET}"; exit 1; }
done
if grep -q "^MAIL=" "$RC_FILE"; then
	sed -i "s|^MAIL=.*|MAIL=$MAIL|" "$RC_FILE"
else
	printf "\nMAIL=%s" "$MAIL" >> "$RC_FILE"
fi
read -rp "Url libft repository : " LIBFT_REPO_URL || { echo -e "${RED}Failed to read input.${RESET}"; exit 1; }
while [[ -z "${LIBFT_REPO_URL// }" ]]; do
	echo -e "${YELLOW}The libft repository URL cannot be empty.${RESET}"
	read -rp "Url libft repository : " LIBFT_REPO_URL || { echo -e "${RED}Failed to read input.${RESET}"; exit 1; }
done
if grep -q "^LIBFT_REPO_URL=" "$RC_FILE"; then
	sed -i "s|^LIBFT_REPO_URL=.*|LIBFT_REPO_URL=$LIBFT_REPO_URL|" "$RC_FILE"
else
	printf "\nLIBFT_REPO_URL=%s" "$LIBFT_REPO_URL" >> "$RC_FILE"
fi
printf "\nexport USER MAIL LIBFT_REPO_URL\n" >> "$RC_FILE"

# Return to the old directory and clean up the temporary directory
cd "$PWD_DIR" || { echo -e "${RED}Unable to return to the old directory.${RESET}"; exit 1; }
rm -rf "$TEMP_DIR" || { echo -e "${RED}Failed to delete the temporary directory.${RESET}"; exit 1; }

# Display a success message
echo -e "${GREEN}Best Script installation completed successfully.${RESET}"

# Restart the shell to apply changes
exec "$SHELL"
