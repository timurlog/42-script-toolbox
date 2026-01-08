#!/bin/bash

set -euo pipefail

# Color codes for quick status output
YELLOW="\033[1;33m"
RED="\033[0;91m"
GREEN="\033[1;32m"
BLUE="\033[0;94m"
MAGENTA="\033[0;95m"
RESET="\033[0m"

# Variables
REPO_URL="${LIBFT_REPO_URL:-}"
TEMP_ROOT="$HOME/temp_____"
PROJECT_DIR="$(pwd)"

# Check if REPO_URL is set
if [[ -z "$REPO_URL" ]]; then
	echo -e "${RED}LIBFT_REPO_URL is not set. Please set it in your environment.${RESET}"
	echo -e "${YELLOW}Example: export LIBFT_REPO_URL=\"git@github.com:user/libft.git\"${RESET}"
	exit 1
fi

if [[ ! -f "$PROJECT_DIR/include/libft.h" || ! -d "$PROJECT_DIR/libft" ]]; then
	echo -e "${RED}include/libft.h or the libft/ directory is not found in $(pwd).${RESET}"
	exit 1
fi

trap 'rm -rf "$TEMP_ROOT"' EXIT

mkdir -p "$TEMP_ROOT" || { echo -e "${RED}Failed to create the temporary root directory.${RESET}"; exit 1; }
CLONE_DIR="$(mktemp -d "${TEMP_ROOT%/}/libft-clone-XXXXXX")" || { echo -e "${RED}Failed to create the temporary clone directory.${RESET}"; exit 1; }

echo -e "${YELLOW}Cloning the libft repository...${RESET}"
git clone --recursive "$REPO_URL" "$CLONE_DIR" > /dev/null 2>&1 || { echo -e "${RED}Failed to clone the repository.${RESET}"; exit 1; }

echo -e "${BLUE}Copying local sources to the clone...${RESET}"
mkdir -p "$CLONE_DIR/include" || { echo -e "${RED}Failed to create include directory in clone.${RESET}"; exit 1; }
cp "$PROJECT_DIR/include/libft.h" "$CLONE_DIR/include/libft.h" || { echo -e "${RED}Failed to copy local libft.h.${RESET}"; exit 1; }
rm -rf "$CLONE_DIR/libft"
cp -r "$PROJECT_DIR/libft" "$CLONE_DIR/libft" || { echo -e "${RED}Failed to copy local libft sources.${RESET}"; exit 1; }

read -rp "Commit message to use: " COMMIT_MSG
while [[ -z "${COMMIT_MSG// }" ]]; do
	echo -e "${YELLOW}The message cannot be empty.${RESET}"
	read -rp "Commit message to use: " COMMIT_MSG
done

pushd "$CLONE_DIR" >/dev/null

git add include/libft.h libft > /dev/null 2>&1 || { echo -e "${RED}Failed to stage changes.${RESET}"; popd >/dev/null; exit 1; }

if git diff --cached --quiet; then
	echo -e "${YELLOW}No changes detected after copying; nothing to commit.${RESET}"
	popd >/dev/null
	exit 0
fi

git commit -m "$COMMIT_MSG" > /dev/null 2>&1 || { echo -e "${RED}Failed to commit changes.${RESET}"; popd >/dev/null; exit 1; }

git push > /dev/null 2>&1 || { echo -e "${RED}Failed to push changes. Please push manually.${RESET}"; popd >/dev/null; exit 1; }

popd >/dev/null

echo -e "${GREEN}Successfully updated and pushed changes to the libft repository.${RESET}"
