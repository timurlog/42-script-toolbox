#!/bin/bash
#
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                         42 C++ MAKEFILE GENERATOR                            ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

set -euo pipefail

# ─────────────────────────────────────────────────────────────────────────────────
# SETUP
# ─────────────────────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# Source dependencies
if [[ -f "$SCRIPT_DIR/common.sh" ]]; then
    source "$SCRIPT_DIR/common.sh"
else
    echo "Error: common.sh not found" >&2
    exit 1
fi

source "$SCRIPT_DIR/header42.sh" || { log_error "Failed to source header42.sh"; exit 1; }

# ─────────────────────────────────────────────────────────────────────────────────
# VARIABLES
# ─────────────────────────────────────────────────────────────────────────────────

DATE=$(date +"%Y/%m/%d %H:%M:%S")
PROJECT_NAME=$(get_project_name)
USERNAME=$(get_user)
USERMAIL="${MAIL:-}"

# ─────────────────────────────────────────────────────────────────────────────────
# VALIDATION
# ─────────────────────────────────────────────────────────────────────────────────

validate_env() {
    [[ -z "$PROJECT_NAME" ]] && { log_error "Project name is empty."; exit 1; }
    [[ -z "$USERNAME" ]] && { log_error "Username not found."; exit 1; }
    
    if [[ -z "$USERMAIL" ]]; then
        read_input "Enter your 42 email" USERMAIL "📧"
    fi
}

# ─────────────────────────────────────────────────────────────────────────────────
# MAKEFILE GENERATOR
# ─────────────────────────────────────────────────────────────────────────────────

generate_cpp_makefile() {
    {
        generate_42_header "Makefile" "$USERNAME" "$USERMAIL" "$DATE"
        cat << MAKEFILE_EOF

# ════════════════════════════════════════════════════════════════════════════ #
#                                  CONFIG                                      #
# ════════════════════════════════════════════════════════════════════════════ #

NAME		= $PROJECT_NAME
INCLUDE		= include
SRC_DIR		= src/
OBJ_DIR		= obj/

CXX			= c++
CXXFLAGS	= -Wall -Werror -Wextra -std=c++98 -I \$(INCLUDE)
RM			= rm -f

# ════════════════════════════════════════════════════════════════════════════ #
#                                  COLORS                                      #
# ════════════════════════════════════════════════════════════════════════════ #

DEF_COLOR	= \e[0;39m
GRAY		= \e[0;90m
RED			= \e[0;91m
GREEN		= \e[0;92m
YELLOW		= \e[0;93m
BLUE		= \e[0;94m
MAGENTA		= \e[0;95m
CYAN		= \e[0;96m
WHITE		= \e[0;97m

# ════════════════════════════════════════════════════════════════════════════ #
#                                  SOURCES                                     #
# ════════════════════════════════════════════════════════════════════════════ #

SRC_FILES	=

SRC			= \$(addprefix \$(SRC_DIR), \$(addsuffix .cpp, \$(SRC_FILES)))
OBJ			= \$(addprefix \$(OBJ_DIR), \$(addsuffix .o, \$(SRC_FILES)))
OBJF		= obj/.cache_exists

# ════════════════════════════════════════════════════════════════════════════ #
#                                  RULES                                       #
# ════════════════════════════════════════════════════════════════════════════ #

all:		\$(NAME)

\$(NAME):	\$(OBJ)
			@\$(CXX) \$(CXXFLAGS) \$(OBJ) -o \$(NAME)
			@printf "\$(GREEN)✓ $PROJECT_NAME compiled!\$(DEF_COLOR)\n"

\$(OBJ_DIR)%.o: \$(SRC_DIR)%.cpp | \$(OBJF)
			@printf "\$(YELLOW)  Compiling: \$<\$(DEF_COLOR)\n"
			@\$(CXX) \$(CXXFLAGS) -c \$< -o \$@

\$(OBJF):
			@mkdir -p \$(OBJ_DIR)
			@touch \$(OBJF)

clean:
			@\$(RM) -rf \$(OBJ_DIR)
			@\$(RM) -f \$(OBJF)
			@printf "\$(BLUE)✓ $PROJECT_NAME object files cleaned!\$(DEF_COLOR)\n"

fclean:		clean
			@\$(RM) -f \$(NAME)
			@printf "\$(CYAN)✓ $PROJECT_NAME executable cleaned!\$(DEF_COLOR)\n"

re:			fclean all
			@printf "\$(GREEN)✓ $PROJECT_NAME recompiled!\$(DEF_COLOR)\n"

.PHONY:		all clean fclean re
MAKEFILE_EOF
    } > Makefile
    
    log_dim "Created C++ Makefile for: $PROJECT_NAME"
}

# ─────────────────────────────────────────────────────────────────────────────────
# MAIN
# ─────────────────────────────────────────────────────────────────────────────────

main() {
    validate_env
    generate_cpp_makefile
}

main "$@"
