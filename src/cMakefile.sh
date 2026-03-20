#!/bin/bash
#
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                          42 C MAKEFILE GENERATOR                             ║
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
# MAKEFILE GENERATORS
# ─────────────────────────────────────────────────────────────────────────────────

generate_program_makefile() {
    {
        generate_42_header "Makefile" "$USERNAME" "$USERMAIL" "$DATE"
        cat << MAKEFILE_EOF

# ════════════════════════════════════════════════════════════════════════════ #
#                                  CONFIG                                      #
# ════════════════════════════════════════════════════════════════════════════ #

PROG		= $PROJECT_NAME
INCLUDE		= include
LIBFT		= libft
SRC_DIR		= src/
OBJ_DIR		= obj/

CC			= cc
CFLAGS		= -Wall -Werror -Wextra -I \$(INCLUDE)
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

SRC			= \$(addprefix \$(SRC_DIR), \$(addsuffix .c, \$(SRC_FILES)))
OBJ			= \$(addprefix \$(OBJ_DIR), \$(addsuffix .o, \$(SRC_FILES)))
OBJF		= obj/.cache_exists

# ════════════════════════════════════════════════════════════════════════════ #
#                                  RULES                                       #
# ════════════════════════════════════════════════════════════════════════════ #

all:		\$(PROG)

\$(PROG):	\$(OBJ)
			@make --no-print-directory -C \$(LIBFT)
			@\$(CC) \$(OBJ) -L\$(LIBFT) -lft -o \$(PROG)
			@echo -e "\$(GREEN)✓ $PROJECT_NAME compiled!\$(DEF_COLOR)"

\$(OBJ_DIR)%.o: \$(SRC_DIR)%.c | \$(OBJF)
			@echo -e "\$(YELLOW)  Compiling: \$<\$(DEF_COLOR)"
			@\$(CC) \$(CFLAGS) -c \$< -o \$@

\$(OBJF):
			@mkdir -p \$(OBJ_DIR)
			@touch \$(OBJF)

clean:
			@\$(RM) -rf \$(OBJ_DIR)
			@\$(RM) -f \$(OBJF)
			@make clean --no-print-directory -C \$(LIBFT)
			@echo -e "\$(BLUE)✓ $PROJECT_NAME object files cleaned!\$(DEF_COLOR)"

fclean:		clean
			@\$(RM) -f \$(PROG)
			@\$(RM) -f \$(LIBFT)/libft.a
			@echo -e "\$(CYAN)✓ libft executables cleaned!\$(DEF_COLOR)"
			@echo -e "\$(CYAN)✓ $PROJECT_NAME executables cleaned!\$(DEF_COLOR)"

re:			fclean all
			@echo -e "\$(GREEN)✓ $PROJECT_NAME recompiled!\$(DEF_COLOR)"

norm:
			@echo -e "\$(MAGENTA)Running norminette...\$(DEF_COLOR)"
			@norminette \$(LIBFT) \$(INCLUDE) \$(SRC_DIR) 2>/dev/null | grep -v "OK!" || true

.PHONY:		all clean fclean re norm
MAKEFILE_EOF
    } > Makefile
}

generate_library_makefile() {
    {
        generate_42_header "Makefile" "$USERNAME" "$USERMAIL" "$DATE"
        cat << MAKEFILE_EOF

# ════════════════════════════════════════════════════════════════════════════ #
#                                  CONFIG                                      #
# ════════════════════════════════════════════════════════════════════════════ #

NAME		= $PROJECT_NAME.a
INCLUDE		= include
SRC_DIR		= src/
OBJ_DIR		= obj/

CC			= cc
CFLAGS		= -Wall -Werror -Wextra -I \$(INCLUDE)
RM			= rm -f
AR			= ar rcs

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

SRC			= \$(addprefix \$(SRC_DIR), \$(addsuffix .c, \$(SRC_FILES)))
OBJ			= \$(addprefix \$(OBJ_DIR), \$(addsuffix .o, \$(SRC_FILES)))
OBJF		= obj/.cache_exists

# ════════════════════════════════════════════════════════════════════════════ #
#                                  RULES                                       #
# ════════════════════════════════════════════════════════════════════════════ #

all:		\$(NAME)

\$(NAME):	\$(OBJ)
			@\$(AR) \$(NAME) \$(OBJ)
			@ranlib \$(NAME)
			@echo -e "\$(GREEN)✓ $PROJECT_NAME.a compiled!\$(DEF_COLOR)"

\$(OBJ_DIR)%.o: \$(SRC_DIR)%.c | \$(OBJF)
			@echo -e "\$(YELLOW)  Compiling: \$<\$(DEF_COLOR)"
			@\$(CC) \$(CFLAGS) -c \$< -o \$@

\$(OBJF):
			@mkdir -p \$(OBJ_DIR)
			@touch \$(OBJF)

clean:
			@\$(RM) -rf \$(OBJ_DIR)
			@\$(RM) -f \$(OBJF)
			@echo -e "\$(BLUE)✓ $PROJECT_NAME object files cleaned!\$(DEF_COLOR)"

fclean:		clean
			@\$(RM) -f \$(NAME)
			@echo -e "\$(CYAN)✓ $PROJECT_NAME library files cleaned!\$(DEF_COLOR)"

re:			fclean all
			@echo -e "\$(GREEN)✓ $PROJECT_NAME.a recompiled!\$(DEF_COLOR)"

norm:
			@echo -e "\$(MAGENTA)Running norminette...\$(DEF_COLOR)"
			@norminette \$(INCLUDE) \$(SRC_DIR) 2>/dev/null | grep -v "OK!" || true

.PHONY:		all clean fclean re norm
MAKEFILE_EOF
    } > Makefile
}

# ─────────────────────────────────────────────────────────────────────────────────
# MAIN
# ─────────────────────────────────────────────────────────────────────────────────

main() {
    validate_env
    
    echo ""
    echo -e "  ${C_YELLOW}?${C_RESET} Project type:"
    echo -e "    ${C_CYAN}1)${C_RESET} Program ${C_DIM}(executable)${C_RESET}"
    echo -e "    ${C_CYAN}2)${C_RESET} Library ${C_DIM}(.a static library)${C_RESET}"
    echo ""
    
    local choice
    while true; do
        echo -ne "  ${C_CYAN}${S_ARROW}${C_RESET} Choice ${C_DIM}[1-2]${C_RESET}: ${C_BOLD}"
        read -r choice || { echo -e "${C_RESET}"; return 1; }
        echo -ne "${C_RESET}"
        
        case "$choice" in
            1|p|P|prog|program)
                generate_program_makefile
                log_dim "Created Makefile for program: $PROJECT_NAME"
                return 0
                ;;
            2|l|L|lib|library)
                generate_library_makefile
                log_dim "Created Makefile for library: $PROJECT_NAME.a"
                return 0
                ;;
            *)
                log_warning "Please enter 1 (Program) or 2 (Library)"
                ;;
        esac
    done
}

main "$@"
