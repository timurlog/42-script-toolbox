#!/bin/bash
#
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                          42 SCRIPT TOOLBOX - HELP                            ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

set -euo pipefail

# ─────────────────────────────────────────────────────────────────────────────────
# SETUP
# ─────────────────────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# Source common library
if [[ -f "$SCRIPT_DIR/common.sh" ]]; then
    source "$SCRIPT_DIR/common.sh"
else
    # Fallback colors if common.sh not found
    C_RESET="\033[0m"
    C_BOLD="\033[1m"
    C_DIM="\033[2m"
    C_CYAN="\033[38;5;51m"
    C_YELLOW="\033[38;5;220m"
    C_GREEN="\033[38;5;82m"
    C_MAGENTA="\033[38;5;201m"
    C_WHITE="\033[38;5;255m"
    C_GRAY="\033[38;5;245m"
    C_ORANGE="\033[38;5;208m"
fi

# ─────────────────────────────────────────────────────────────────────────────────
# HELP CONTENT
# ─────────────────────────────────────────────────────────────────────────────────

show_commands() {
    echo -e "  ${C_CYAN}${C_BOLD}━━━ COMMANDS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    echo ""
    
    # New Project
    echo -e "  ${C_GREEN}${C_BOLD}snew${C_RESET}      ${C_DIM}│${C_RESET} Create a new 42 project"
    echo -e "            ${C_DIM}│${C_RESET} ${C_GRAY}• Initialize git repository${C_RESET}"
    echo -e "            ${C_DIM}│${C_RESET} ${C_GRAY}• Generate .gitignore${C_RESET}"
    echo -e "            ${C_DIM}│${C_RESET} ${C_GRAY}• Create Makefile (C/C++)${C_RESET}"
    echo -e "            ${C_DIM}│${C_RESET} ${C_GRAY}• Setup folder structure${C_RESET}"
    echo -e "            ${C_DIM}│${C_RESET} ${C_GRAY}• Optional libft integration${C_RESET}"
    echo ""
    
    # Add Libft
    echo -e "  ${C_GREEN}${C_BOLD}slib${C_RESET}      ${C_DIM}│${C_RESET} Add libft to current project"
    echo -e "            ${C_DIM}│${C_RESET} ${C_GRAY}• Clone from your LIBFT_REPO_URL${C_RESET}"
    echo -e "            ${C_DIM}│${C_RESET} ${C_GRAY}• Copy sources to libft/${C_RESET}"
    echo -e "            ${C_DIM}│${C_RESET} ${C_GRAY}• Copy header to include/${C_RESET}"
    echo ""
    
    # Create Makefile
    echo -e "  ${C_GREEN}${C_BOLD}smake${C_RESET}     ${C_DIM}│${C_RESET} Generate a Makefile"
    echo -e "            ${C_DIM}│${C_RESET} ${C_GRAY}• Choose C or C++${C_RESET}"
    echo -e "            ${C_DIM}│${C_RESET} ${C_GRAY}• Program or Library mode${C_RESET}"
    echo -e "            ${C_DIM}│${C_RESET} ${C_GRAY}• Auto 42 header generation${C_RESET}"
    echo ""
    
    # Gitignore
    echo -e "  ${C_GREEN}${C_BOLD}signore${C_RESET}   ${C_DIM}│${C_RESET} Generate .gitignore"
    echo -e "            ${C_DIM}│${C_RESET} ${C_GRAY}• C/C++, Python, Web patterns${C_RESET}"
    echo -e "            ${C_DIM}│${C_RESET} ${C_GRAY}• IDE files (VSCode, Vim, etc.)${C_RESET}"
    echo -e "            ${C_DIM}│${C_RESET} ${C_GRAY}• OS files (macOS, Linux, Windows)${C_RESET}"
    echo ""
    
    # Push Libft
    echo -e "  ${C_GREEN}${C_BOLD}spush${C_RESET}     ${C_DIM}│${C_RESET} Push libft changes to your repo"
    echo -e "            ${C_DIM}│${C_RESET} ${C_GRAY}• Sync local libft/ and include/libft.h${C_RESET}"
    echo -e "            ${C_DIM}│${C_RESET} ${C_GRAY}• Commit with custom message${C_RESET}"
    echo -e "            ${C_DIM}│${C_RESET} ${C_GRAY}• Push to LIBFT_REPO_URL${C_RESET}"
    echo ""
    
    # Utility commands
    echo -e "  ${C_CYAN}${C_BOLD}━━━ UTILITY ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    echo ""
    
    echo -e "  ${C_YELLOW}${C_BOLD}supdate${C_RESET}   ${C_DIM}│${C_RESET} Update the toolbox"
    echo ""
    
    echo -e "  ${C_YELLOW}${C_BOLD}shelp${C_RESET}     ${C_DIM}│${C_RESET} Show this help message"
    echo ""
    
    echo -e "  ${C_YELLOW}${C_BOLD}sversion${C_RESET}  ${C_DIM}│${C_RESET} Show version and system info"
    echo ""
}

show_configuration() {
    echo -e "  ${C_CYAN}${C_BOLD}━━━ CONFIGURATION ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    echo ""
    echo -e "  ${C_WHITE}Environment variables in ${C_MAGENTA}~/.zshrc${C_WHITE}:${C_RESET}"
    echo ""
    
    # USER
    local user_val="${USER:-${C_RED}not set${C_RESET}}"
    echo -e "  ${C_ORANGE}USER${C_RESET}           ${C_DIM}│${C_RESET} Your 42 login"
    echo -e "                 ${C_DIM}│${C_RESET} ${C_GRAY}Current: ${C_WHITE}${user_val}${C_RESET}"
    echo ""
    
    # MAIL
    local mail_val="${MAIL:-${C_RED}not set${C_RESET}}"
    echo -e "  ${C_ORANGE}MAIL${C_RESET}           ${C_DIM}│${C_RESET} Your 42 email"
    echo -e "                 ${C_DIM}│${C_RESET} ${C_GRAY}Current: ${C_WHITE}${mail_val}${C_RESET}"
    echo ""
    
    # LIBFT_REPO_URL
    local libft_val="${LIBFT_REPO_URL:-${C_RED}not set${C_RESET}}"
    echo -e "  ${C_ORANGE}LIBFT_REPO_URL${C_RESET} ${C_DIM}│${C_RESET} Your libft git repository"
    echo -e "                 ${C_DIM}│${C_RESET} ${C_GRAY}Current: ${C_WHITE}${libft_val}${C_RESET}"
    echo ""
}

show_examples() {
    echo -e "  ${C_CYAN}${C_BOLD}━━━ EXAMPLES ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    echo ""
    echo -e "  ${C_WHITE}Create a new project:${C_RESET}"
    echo -e "  ${C_DIM}\$ ${C_GREEN}snew${C_RESET}"
    echo -e "  ${C_GRAY}  → Enter project name, choose options, done!${C_RESET}"
    echo ""
    echo -e "  ${C_WHITE}Add libft to existing project:${C_RESET}"
    echo -e "  ${C_DIM}\$ cd my_project${C_RESET}"
    echo -e "  ${C_DIM}\$ ${C_GREEN}slib${C_RESET}"
    echo ""
    echo -e "  ${C_WHITE}Update your libft after adding functions:${C_RESET}"
    echo -e "  ${C_DIM}\$ ${C_GREEN}spush${C_RESET}"
    echo -e "  ${C_GRAY}  → Enter commit message, changes are pushed${C_RESET}"
    echo ""
    echo -e "  ${C_WHITE}Update the toolbox:${C_RESET}"
    echo -e "  ${C_DIM}\$ ${C_GREEN}supdate${C_RESET}"
    echo ""
}

show_footer() {
    echo -e "  ${C_DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    echo ""
    echo -e "  ${C_DIM}GitHub: ${C_CYAN}https://github.com/timurlog/42-script-toolbox${C_RESET}"
    echo -e "  ${C_DIM}Made with ${C_RED}♥${C_DIM} for 42 students${C_RESET}"
    echo ""
}

# ─────────────────────────────────────────────────────────────────────────────────
# SPECIFIC COMMAND HELP
# ─────────────────────────────────────────────────────────────────────────────────

show_command_help() {
    local cmd="$1"
    
    case "$cmd" in
        snew|new|newproject)
            echo ""
            echo -e "  ${C_GREEN}${C_BOLD}snew${C_RESET} - Create a new 42 project"
            echo ""
            echo -e "  ${C_WHITE}Usage:${C_RESET}"
            echo -e "    ${C_DIM}\$ snew${C_RESET}"
            echo ""
            echo -e "  ${C_WHITE}Interactive prompts:${C_RESET}"
            echo -e "    ${C_CYAN}1.${C_RESET} Project name"
            echo -e "    ${C_CYAN}2.${C_RESET} Clone existing repo or create new"
            echo -e "    ${C_CYAN}3.${C_RESET} Create Makefile (C/C++)"
            echo -e "    ${C_CYAN}4.${C_RESET} Create src/ folder"
            echo -e "    ${C_CYAN}5.${C_RESET} Create include/ folder"
            echo -e "    ${C_CYAN}6.${C_RESET} Initialize libft"
            echo ""
            ;;
        slib|lib|libft)
            echo ""
            echo -e "  ${C_GREEN}${C_BOLD}slib${C_RESET} - Add libft to current project"
            echo ""
            echo -e "  ${C_WHITE}Usage:${C_RESET}"
            echo -e "    ${C_DIM}\$ cd your_project${C_RESET}"
            echo -e "    ${C_DIM}\$ slib${C_RESET}"
            echo ""
            echo -e "  ${C_WHITE}Requirements:${C_RESET}"
            echo -e "    ${C_CYAN}•${C_RESET} LIBFT_REPO_URL must be set"
            echo ""
            ;;
        smake|make|makefile)
            echo ""
            echo -e "  ${C_GREEN}${C_BOLD}smake${C_RESET} - Generate a Makefile"
            echo ""
            echo -e "  ${C_WHITE}Usage:${C_RESET}"
            echo -e "    ${C_DIM}\$ smake${C_RESET}"
            echo ""
            echo -e "  ${C_WHITE}Options:${C_RESET}"
            echo -e "    ${C_CYAN}•${C_RESET} Language: C or C++"
            echo -e "    ${C_CYAN}•${C_RESET} Type: Program (executable) or Library (.a)"
            echo ""
            ;;
        signore|ignore|gitignore)
            echo ""
            echo -e "  ${C_GREEN}${C_BOLD}signore${C_RESET} - Generate .gitignore"
            echo ""
            echo -e "  ${C_WHITE}Usage:${C_RESET}"
            echo -e "    ${C_DIM}\$ signore${C_RESET}"
            echo ""
            echo -e "  ${C_WHITE}Includes patterns for:${C_RESET}"
            echo -e "    ${C_CYAN}•${C_RESET} C/C++ (objects, binaries)"
            echo -e "    ${C_CYAN}•${C_RESET} Python, Node.js"
            echo -e "    ${C_CYAN}•${C_RESET} IDEs (VSCode, Vim, JetBrains)"
            echo -e "    ${C_CYAN}•${C_RESET} OS files (macOS, Linux, Windows)"
            echo ""
            ;;
        spush|push|update)
            echo ""
            echo -e "  ${C_GREEN}${C_BOLD}spush${C_RESET} - Push libft changes to repository"
            echo ""
            echo -e "  ${C_WHITE}Usage:${C_RESET}"
            echo -e "    ${C_DIM}\$ spush${C_RESET}"
            echo ""
            echo -e "  ${C_WHITE}What it does:${C_RESET}"
            echo -e "    ${C_CYAN}1.${C_RESET} Clones your libft repo"
            echo -e "    ${C_CYAN}2.${C_RESET} Copies local libft/ and include/libft.h"
            echo -e "    ${C_CYAN}3.${C_RESET} Commits with your message"
            echo -e "    ${C_CYAN}4.${C_RESET} Pushes to remote"
            echo ""
            ;;
        supdate|toolbox)
            echo ""
            echo -e "  ${C_GREEN}${C_BOLD}supdate${C_RESET} - Update the toolbox"
            echo ""
            echo -e "  ${C_WHITE}Usage:${C_RESET}"
            echo -e "    ${C_DIM}\$ supdate${C_RESET}"
            echo ""
            echo -e "  ${C_WHITE}What it does:${C_RESET}"
            echo -e "    ${C_CYAN}1.${C_RESET} Pulls latest changes from repository"
            echo -e "    ${C_CYAN}2.${C_RESET} Verifies all scripts are present"
            echo -e "    ${C_CYAN}3.${C_RESET} Checks and fixes aliases"
            echo -e "    ${C_CYAN}4.${C_RESET} Validates environment variables"
            echo ""
            ;;
        shelp|help)
            echo ""
            echo -e "  ${C_YELLOW}${C_BOLD}shelp${C_RESET} - Show help information"
            echo ""
            echo -e "  ${C_WHITE}Usage:${C_RESET}"
            echo -e "    ${C_DIM}\$ shelp${C_RESET}           ${C_GRAY}# Show all commands${C_RESET}"
            echo -e "    ${C_DIM}\$ shelp snew${C_RESET}      ${C_GRAY}# Help for specific command${C_RESET}"
            echo ""
            ;;
        sversion|version)
            echo ""
            echo -e "  ${C_YELLOW}${C_BOLD}sversion${C_RESET} - Show version and system info"
            echo ""
            echo -e "  ${C_WHITE}Usage:${C_RESET}"
            echo -e "    ${C_DIM}\$ sversion${C_RESET}        ${C_GRAY}# Full version info${C_RESET}"
            echo -e "    ${C_DIM}\$ sversion -s${C_RESET}     ${C_GRAY}# Short version only${C_RESET}"
            echo -e "    ${C_DIM}\$ sversion -c${C_RESET}     ${C_GRAY}# Check for updates${C_RESET}"
            echo ""
            ;;
        *)
            echo -e "  ${C_RED}Unknown command: ${cmd}${C_RESET}"
            echo -e "  ${C_DIM}Run 'shelp' for available commands${C_RESET}"
            ;;
    esac
}

# ─────────────────────────────────────────────────────────────────────────────────
# MAIN
# ─────────────────────────────────────────────────────────────────────────────────

main() {
    clear
    
    # Check for specific command help
    if [[ $# -gt 0 ]]; then
        show_command_help "$1"
        exit 0
    fi
    
    show_commands
    show_configuration
    show_examples
    show_footer
}

main "$@"
