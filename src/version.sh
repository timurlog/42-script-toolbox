#!/bin/bash
#
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                        42 SCRIPT TOOLBOX - VERSION                           ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

set -euo pipefail

# ─────────────────────────────────────────────────────────────────────────────────
# VERSION INFO
# ─────────────────────────────────────────────────────────────────────────────────

readonly VERSION="1.0.0"
readonly BUILD_DATE="2025-01-09"
readonly REPO_URL="https://github.com/timurlog/42-script-toolbox"
readonly INSTALL_DIR="$HOME/.script"

# ─────────────────────────────────────────────────────────────────────────────────
# SETUP
# ─────────────────────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# Source common library
if [[ -f "$SCRIPT_DIR/common.sh" ]]; then
    source "$SCRIPT_DIR/common.sh"
else
    # Fallback colors
    C_RESET="\033[0m"
    C_BOLD="\033[1m"
    C_DIM="\033[2m"
    C_CYAN="\033[38;5;51m"
    C_YELLOW="\033[38;5;220m"
    C_GREEN="\033[38;5;82m"
    C_RED="\033[38;5;196m"
    C_MAGENTA="\033[38;5;201m"
    C_WHITE="\033[38;5;255m"
    C_GRAY="\033[38;5;245m"
    C_ORANGE="\033[38;5;208m"
    C_BLUE="\033[38;5;39m"
    S_CHECK="✓"
    S_CROSS="✗"
    S_STAR="★"
    S_ROCKET="🚀"
    S_GEAR="⚙"
fi

# ─────────────────────────────────────────────────────────────────────────────────
# VERSION INFO
# ─────────────────────────────────────────────────────────────────────────────────

show_version() {
    echo ""
    echo -e "  ${C_WHITE}${C_BOLD}Version${C_RESET}      ${C_CYAN}${C_BOLD}${VERSION}${C_RESET}"
    echo -e "  ${C_WHITE}${C_BOLD}Build Date${C_RESET}   ${C_GRAY}${BUILD_DATE}${C_RESET}"
    echo ""
}

# ─────────────────────────────────────────────────────────────────────────────────
# INSTALLATION INFO
# ─────────────────────────────────────────────────────────────────────────────────

show_installation_info() {
    echo -e "  ${C_DIM}━━━ INSTALLATION ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    echo ""
    
    # Install directory
    echo -ne "  ${C_WHITE}Install Path${C_RESET}   "
    if [[ -d "$INSTALL_DIR" ]]; then
        echo -e "${C_GREEN}${S_CHECK}${C_RESET} ${C_GRAY}${INSTALL_DIR}${C_RESET}"
    else
        echo -e "${C_RED}${S_CROSS}${C_RESET} ${C_RED}Not found${C_RESET}"
    fi
    
    # Git info
    echo -ne "  ${C_WHITE}Git Status${C_RESET}     "
    if [[ -d "$INSTALL_DIR/.git" ]]; then
        local commit_hash branch
        cd "$INSTALL_DIR"
        commit_hash=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
        branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
        echo -e "${C_GREEN}${S_CHECK}${C_RESET} ${C_GRAY}${branch}@${commit_hash}${C_RESET}"
        cd - > /dev/null
    else
        echo -e "${C_YELLOW}${S_CROSS}${C_RESET} ${C_YELLOW}Not a git repo${C_RESET}"
    fi
    
    # Scripts count
    echo -ne "  ${C_WHITE}Scripts${C_RESET}        "
    if [[ -d "$INSTALL_DIR/src" ]]; then
        local count
        count=$(find "$INSTALL_DIR/src" -name "*.sh" 2>/dev/null | wc -l)
        echo -e "${C_GREEN}${S_CHECK}${C_RESET} ${C_GRAY}${count} scripts installed${C_RESET}"
    else
        echo -e "${C_RED}${S_CROSS}${C_RESET} ${C_RED}src/ not found${C_RESET}"
    fi
    
    echo ""
}

# ─────────────────────────────────────────────────────────────────────────────────
# ENVIRONMENT INFO
# ─────────────────────────────────────────────────────────────────────────────────

show_environment() {
    echo -e "  ${C_DIM}━━━ ENVIRONMENT ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    echo ""
    
    # USER
    echo -ne "  ${C_WHITE}USER${C_RESET}           "
    if [[ -n "${USER:-}" ]]; then
        echo -e "${C_GREEN}${S_CHECK}${C_RESET} ${C_GRAY}${USER}${C_RESET}"
    else
        echo -e "${C_RED}${S_CROSS}${C_RESET} ${C_RED}Not set${C_RESET}"
    fi
    
    # MAIL
    echo -ne "  ${C_WHITE}MAIL${C_RESET}           "
    if [[ -n "${MAIL:-}" ]]; then
        echo -e "${C_GREEN}${S_CHECK}${C_RESET} ${C_GRAY}${MAIL}${C_RESET}"
    else
        echo -e "${C_RED}${S_CROSS}${C_RESET} ${C_RED}Not set${C_RESET}"
    fi
    
    # LIBFT_REPO_URL
    echo -ne "  ${C_WHITE}LIBFT_REPO_URL${C_RESET} "
    if [[ -n "${LIBFT_REPO_URL:-}" ]]; then
        # Truncate if too long
        local url="${LIBFT_REPO_URL}"
        if [[ ${#url} -gt 40 ]]; then
            url="${url:0:37}..."
        fi
        echo -e "${C_GREEN}${S_CHECK}${C_RESET} ${C_GRAY}${url}${C_RESET}"
    else
        echo -e "${C_RED}${S_CROSS}${C_RESET} ${C_RED}Not set${C_RESET}"
    fi
    
    echo ""
}

# ─────────────────────────────────────────────────────────────────────────────────
# UPDATE CHECK
# ─────────────────────────────────────────────────────────────────────────────────

check_updates() {
    echo -e "  ${C_DIM}━━━ UPDATE CHECK ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    echo ""
    
    if [[ ! -d "$INSTALL_DIR/.git" ]]; then
        echo -e "  ${C_YELLOW}${S_CROSS}${C_RESET} ${C_YELLOW}Cannot check updates (not a git repo)${C_RESET}"
        echo ""
        return
    fi
    
    echo -ne "  ${C_CYAN}⠋${C_RESET} Checking for updates..."
    
    cd "$INSTALL_DIR"
    
    # Fetch updates silently
    if git fetch origin > /dev/null 2>&1; then
        local local_hash remote_hash
        local_hash=$(git rev-parse HEAD 2>/dev/null)
        remote_hash=$(git rev-parse origin/main 2>/dev/null || git rev-parse origin/master 2>/dev/null)
        
        printf "\r%50s\r" ""  # Clear line
        
        if [[ "$local_hash" == "$remote_hash" ]]; then
            echo -e "  ${C_GREEN}${S_CHECK}${C_RESET} ${C_WHITE}You're up to date!${C_RESET}"
        else
            local commits_behind
            commits_behind=$(git rev-list --count HEAD..origin/main 2>/dev/null || git rev-list --count HEAD..origin/master 2>/dev/null || echo "?")
            echo -e "  ${C_YELLOW}${S_STAR}${C_RESET} ${C_YELLOW}Update available!${C_RESET} ${C_GRAY}(${commits_behind} commits behind)${C_RESET}"
            echo ""
            echo -e "  ${C_WHITE}Run the updater:${C_RESET}"
            echo -e "  ${C_DIM}supdate${C_RESET}"
        fi
    else
        printf "\r%50s\r" ""  # Clear line
        echo -e "  ${C_YELLOW}${S_CROSS}${C_RESET} ${C_YELLOW}Could not check for updates${C_RESET}"
    fi
    
    cd - > /dev/null
    echo ""
}

# ─────────────────────────────────────────────────────────────────────────────────
# ALIASES CHECK
# ─────────────────────────────────────────────────────────────────────────────────

show_aliases() {
    echo -e "  ${C_DIM}━━━ ALIASES ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    echo ""
    
    local rc_file="$HOME/.zshrc"
    local aliases=("snew" "slib" "smake" "signore" "spush" "supdate" "shelp" "sversion")
    
    for alias_name in "${aliases[@]}"; do
        echo -ne "  ${C_WHITE}${alias_name}${C_RESET}"
        printf "%*s" $((12 - ${#alias_name})) ""
        
        if grep -q "^alias ${alias_name}=" "$rc_file" 2>/dev/null; then
            echo -e "${C_GREEN}${S_CHECK}${C_RESET} ${C_GRAY}configured${C_RESET}"
        else
            echo -e "${C_RED}${S_CROSS}${C_RESET} ${C_RED}not found${C_RESET}"
        fi
    done
    
    echo ""
}

# ─────────────────────────────────────────────────────────────────────────────────
# FOOTER
# ─────────────────────────────────────────────────────────────────────────────────

show_footer() {
    echo -e "  ${C_DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    echo ""
    echo -e "  ${C_DIM}Repository: ${C_CYAN}${REPO_URL}${C_RESET}"
    echo -e "  ${C_DIM}Report issues: ${C_CYAN}${REPO_URL}/issues${C_RESET}"
    echo ""
}

# ─────────────────────────────────────────────────────────────────────────────────
# MAIN
# ─────────────────────────────────────────────────────────────────────────────────

main() {
    # Handle --short/-s flag
    if [[ "${1:-}" == "--short" || "${1:-}" == "-s" ]]; then
        echo "42 Script Toolbox v${VERSION}"
        exit 0
    fi
    
    # Handle --check/-c flag
    if [[ "${1:-}" == "--check" || "${1:-}" == "-c" ]]; then
        check_updates
        exit 0
    fi
    
    show_version
    show_installation_info
    show_environment
    show_aliases
    check_updates
    show_footer
}

main "$@"
