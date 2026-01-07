#!/bin/bash

# Define color codes for output messages
YELLOW="\033[1;33m"
RED="\033[0;91m"
GREEN="\033[1;32m"
BLUE="\033[0;94m"
MAGENTA="\033[0;95m"
RESET="\033[0m"

# Define variables
date=$(date +"%Y/%m/%d %H:%M:%S") || { echo -e "${RED}Failed to get date.${RESET}"; exit 1; }
project_name=$(basename "$(pwd)") || { echo -e "${RED}Failed to get project name.${RESET}"; exit 1; }
user="${USER:-$(whoami)}"
mail="${MAIL:-}"

# Check if project name is empty
if [[ -z "$project_name" ]]; then
    echo -e "${RED}Project name is empty.${RESET}"
    exit 1
fi

# Check if user is empty
if [[ -z "$user" ]]; then
    echo -e "${RED}Failed to get username.${RESET}"
    exit 1
fi

# Check if mail is empty, ask user if needed
if [[ -z "$mail" ]]; then
    read -p "Enter your 42 email: " mail || { echo -e "${RED}Failed to read email.${RESET}"; exit 1; }
    if [[ -z "$mail" ]]; then
        echo -e "${RED}Email cannot be empty.${RESET}"
        exit 1
    fi
fi

# Source the header generator
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
source "$SCRIPT_DIR/header42.sh" || { echo -e "${RED}Failed to source header42.sh${RESET}"; exit 1; }

# Main script execution starts here
touch Makefile || { echo -e "${RED}Failed to create Makefile.${RESET}"; exit 1; }
{
generate_42_header "Makefile" "$user" "$mail" "$date"
cat <<MAKE_EOF

#Variables

NAME		= $project_name
INCLUDE		= include
SRC_DIR		= src/
OBJ_DIR		= obj/
CXX			= c++
CXXFLAGS	= -Wall -Werror -Wextra -std=c++98 -I \$(INCLUDE)
RM			= rm -f

# Colors

DEF_COLOR = \e[0;39m
GRAY = \e[0;90m
RED = \e[0;91m
GREEN = \e[0;92m
YELLOW = \e[0;93m
BLUE = \e[0;94m
MAGENTA = \e[0;95m
CYAN = \e[0;96m
WHITE = \e[0;97m

#Sources

SRC_FILES	=	main


SRC 		= 	\$(addprefix \$(SRC_DIR), \$(addsuffix .cpp, \$(SRC_FILES)))
OBJ 		= 	\$(addprefix \$(OBJ_DIR), \$(addsuffix .o, \$(SRC_FILES)))

###

OBJF		=	.cache_exists

all:		\$(NAME)

\$(NAME):	\$(OBJ)
			@\$(CXX) \$(CXXFLAGS) \$(OBJ) -o \$(NAME)
			@echo "\$(GREEN)$project_name compiled!\$(DEF_COLOR)"

\$(OBJ_DIR)%.o: \$(SRC_DIR)%.cpp | \$(OBJF)
			@echo "\$(YELLOW)Compiling: \$< \$(DEF_COLOR)"
			@\$(CXX) \$(CXXFLAGS) -c \$< -o \$@

\$(OBJF):
			@mkdir -p \$(OBJ_DIR)

clean:
			@\$(RM) -rf \$(OBJ_DIR)
			@echo "\$(BLUE)$project_name object files cleaned!\$(DEF_COLOR)"

fclean:		clean
			@\$(RM) -f \$(NAME)
			@echo "\$(CYAN)$project_name executable files cleaned!\$(DEF_COLOR)"

re:			fclean all
			@echo "\$(GREEN)Cleaned and rebuilt everything for $project_name!\$(DEF_COLOR)"

.PHONY:		all clean fclean re
MAKE_EOF
} > Makefile
