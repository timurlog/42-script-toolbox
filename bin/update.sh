#!/bin/bash
#
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                         42 SCRIPT TOOLBOX UPDATER                            ║
# ║                                                                              ║
# ║  Updates your installation and verifies configuration                        ║
# ║  Repository: https://github.com/timurlog/42-script-toolbox                   ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

set -euo pipefail

# ─────────────────────────────────────────────────────────────────────────────────
# CONFIGURATION
# ─────────────────────────────────────────────────────────────────────────────────

readonly REPO_URL="https://github.com/timurlog/42-script-toolbox.git"
readonly INSTALL_DIR="$HOME/.script"
readonly RC_FILE="$HOME/.zshrc"
readonly SCRIPT_VERSION="1.1.0"

# ─────────────────────────────────────────────────────────────────────────────────
# COLORS & SYMBOLS
# ─────────────────────────────────────────────────────────────────────────────────

readonly C_RESET="\033[0m"
readonly C_BOLD="\033[1m"
readonly C_DIM="\033[2m"

readonly C_RED="\033[38;5;196m"
readonly C_GREEN="\033[38;5;82m"
readonly C_YELLOW="\033[38;5;220m"
readonly C_BLUE="\033[38;5;39m"
readonly C_MAGENTA="\033[38;5;201m"
readonly C_CYAN="\033[38;5;51m"
readonly C_WHITE="\033[38;5;255m"
readonly C_GRAY="\033[38;5;245m"
readonly C_ORANGE="\033[38;5;208m"

readonly S_CHECK="✓"
readonly S_CROSS="✗"
readonly S_ARROW="→"
readonly S_DOT="•"
readonly S_STAR="★"
readonly S_GEAR="⚙"
readonly S_SYNC="🔄"
readonly S_SHIELD="🛡"
readonly S_ROCKET="🚀"
readonly S_WARN="⚠"
readonly S_LINK="🔗"

# ─────────────────────────────────────────────────────────────────────────────────
# LOGGING FUNCTIONS
# ─────────────────────────────────────────────────────────────────────────────────

log_info() {
    echo -e "  ${C_CYAN}${S_DOT}${C_RESET} ${C_WHITE}$1${C_RESET}"
}

log_success() {
    echo -e "  ${C_GREEN}${S_CHECK}${C_RESET} ${C_WHITE}$1${C_RESET}"
}

log_warning() {
    echo -e "  ${C_ORANGE}${S_WARN}${C_RESET} ${C_YELLOW}$1${C_RESET}"
}

log_error() {
    echo -e "  ${C_RED}${S_CROSS}${C_RESET} ${C_RED}$1${C_RESET}"
}

log_step() {
    echo -e "\n  ${C_MAGENTA}${S_GEAR}${C_RESET} ${C_BOLD}$1${C_RESET}"
}

log_dim() {
    echo -e "    ${C_GRAY}${C_DIM}$1${C_RESET}"
}

# ─────────────────────────────────────────────────────────────────────────────────
# BANNER
# ─────────────────────────────────────────────────────────────────────────────────

show_banner() {
    echo -e "${C_CYAN}"
    cat << 'EOF'

     ██╗  ██╗██████╗     ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗
     ██║  ██║╚════██╗    ██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝
     ███████║ █████╔╝    ███████╗██║     ██████╔╝██║██████╔╝   ██║   
     ╚════██║██╔═══╝     ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║   
          ██║███████╗    ███████║╚██████╗██║  ██║██║██║        ██║   
          ╚═╝╚══════╝    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   

EOF
    echo -e "${C_RESET}"
    echo -e "             ${C_BOLD}${C_WHITE}T O O L B O X   U P D A T E R${C_RESET}"
    echo -e "             ${C_DIM}${C_GRAY}Version ${SCRIPT_VERSION}${C_RESET}\n"
    echo -e "  ${C_DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
}

# ─────────────────────────────────────────────────────────────────────────────────
# UTILITY FUNCTIONS
# ─────────────────────────────────────────────────────────────────────────────────

spinner() {
    local pid=$1
    local message=$2
    local spin_chars='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0

    while kill -0 "$pid" 2>/dev/null; do
        printf "\r  ${C_CYAN}%s${C_RESET} %s" "${spin_chars:i++%${#spin_chars}:1}" "$message"
        sleep 0.1
    done
    printf "\r"
}

# ─────────────────────────────────────────────────────────────────────────────────
# UPDATE FUNCTIONS
# ─────────────────────────────────────────────────────────────────────────────────

check_installation() {
    log_step "Checking installation..."
    
    if [[ ! -d "$INSTALL_DIR" ]]; then
        log_error "Installation directory not found: ${C_CYAN}${INSTALL_DIR}${C_RESET}"
        log_info "Please run the installer first."
        exit 1
    fi
    
    if [[ ! -d "$INSTALL_DIR/.git" ]]; then
        log_error "Not a git repository. Cannot update."
        log_info "Please reinstall using the installer script."
        exit 1
    fi
    
    log_success "Installation found at ${C_CYAN}${INSTALL_DIR}${C_RESET}"
}

get_current_version() {
    cd "$INSTALL_DIR" || exit 1
    local current_hash
    current_hash=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
    log_dim "Current commit: ${current_hash}"
}

pull_updates() {
    log_step "Pulling updates..."
    
    cd "$INSTALL_DIR" || { log_error "Cannot access installation directory."; exit 1; }
    
    get_current_version
    
    # Fetch updates
    log_info "Fetching from remote..."
    git fetch origin > /dev/null 2>&1 &
    local pid=$!
    spinner $pid "Checking for updates..."
    wait $pid || { log_error "Failed to fetch from repository."; exit 1; }
    
    # Check if updates are available
    local local_hash remote_hash
    local_hash=$(git rev-parse HEAD)
    remote_hash=$(git rev-parse origin/main 2>/dev/null || git rev-parse origin/master 2>/dev/null)
    
    if [[ "$local_hash" == "$remote_hash" ]]; then
        log_success "Already up to date!"
        return 0
    fi
    
    # Count commits behind
    local commits_behind
    commits_behind=$(git rev-list --count HEAD..origin/main 2>/dev/null || git rev-list --count HEAD..origin/master 2>/dev/null || echo "?")
    log_info "Updates available: ${C_CYAN}${commits_behind}${C_RESET} new commit(s)"
    
    # Reset to latest
    log_info "Applying updates..."
    git reset --hard origin/main > /dev/null 2>&1 || git reset --hard origin/master > /dev/null 2>&1 || { 
        log_error "Failed to apply updates."
        exit 1
    }
    
    # Update submodules
    if [[ -f ".gitmodules" ]]; then
        log_info "Updating submodules..."
        git submodule update --init --recursive > /dev/null 2>&1 || {
            log_warning "Failed to update some submodules."
        }
    fi
    
    local new_hash
    new_hash=$(git rev-parse --short HEAD)
    log_success "Updated to commit: ${C_CYAN}${new_hash}${C_RESET}"
}

verify_aliases() {
    log_step "Verifying aliases..."
    
    if [[ ! -f "$RC_FILE" ]]; then
        log_warning "Shell config not found: ${C_CYAN}${RC_FILE}${C_RESET}"
        return 1
    fi
    
    local alias_names=("npro" "alibft" "acomp" "agit" "ulibft")
    local alias_cmds=(
        "bash ${INSTALL_DIR}/src/newProject.sh"
        "bash ${INSTALL_DIR}/src/libft.sh"
        "bash ${INSTALL_DIR}/src/compiler.sh"
        "bash ${INSTALL_DIR}/src/gitignore.sh"
        "bash ${INSTALL_DIR}/src/updateLibft.sh"
    )
    
    local ok=0
    local missing=0
    local fixed=0
    local i
    
    for i in "${!alias_names[@]}"; do
        local name="${alias_names[$i]}"
        local expected_cmd="${alias_cmds[$i]}"
        
        if grep -q "^alias ${name}=" "$RC_FILE" 2>/dev/null; then
            local current_cmd
            current_cmd=$(grep "^alias ${name}=" "$RC_FILE" | sed "s/^alias ${name}='\\(.*\\)'$/\\1/")
            
            if [[ "$current_cmd" == "$expected_cmd" ]]; then
                ((ok++)) || true
            else
                # Fix incorrect alias
                sed -i "s|^alias ${name}=.*|alias ${name}='${expected_cmd}'|" "$RC_FILE"
                ((fixed++)) || true
            fi
        else
            # Add missing alias
            printf "\nalias %s='%s'" "$name" "$expected_cmd" >> "$RC_FILE"
            ((missing++)) || true
        fi
    done
    
    # Build status message
    local status_parts=()
    [[ $ok -gt 0 ]] && status_parts+=("${C_GREEN}${ok} valid${C_RESET}")
    [[ $fixed -gt 0 ]] && status_parts+=("${C_YELLOW}${fixed} fixed${C_RESET}")
    [[ $missing -gt 0 ]] && status_parts+=("${C_CYAN}${missing} added${C_RESET}")
    
    local status_msg
    status_msg=$(IFS=', '; echo "${status_parts[*]}")
    log_success "Aliases: ${status_msg}"
}

verify_exports() {
    log_step "Verifying environment variables..."
    
    if [[ ! -f "$RC_FILE" ]]; then
        return 1
    fi
    
    local vars=("USER" "MAIL" "LIBFT_REPO_URL")
    local configured=0
    local missing_vars=()
    
    for var in "${vars[@]}"; do
        if grep -q "^${var}=" "$RC_FILE" 2>/dev/null; then
            local value
            value=$(grep "^${var}=" "$RC_FILE" | head -1 | cut -d '=' -f2-)
            if [[ -n "$value" ]]; then
                ((configured++)) || true
            else
                missing_vars+=("$var")
            fi
        else
            missing_vars+=("$var")
        fi
    done
    
    # Check export statement
    local export_ok=false
    if grep -Eq "^[[:space:]]*export.*(USER|MAIL|LIBFT_REPO_URL)" "$RC_FILE"; then
        export_ok=true
    else
        printf "\nexport USER MAIL LIBFT_REPO_URL\n" >> "$RC_FILE"
    fi
    
    # Report status
    if [[ ${#missing_vars[@]} -eq 0 ]]; then
        log_success "All ${C_CYAN}${configured}${C_RESET}${C_WHITE} variables configured${C_RESET}"
        [[ "$export_ok" == false ]] && log_info "Added missing export statement"
    else
        log_success "${C_CYAN}${configured}${C_RESET}${C_WHITE}/${#vars[@]} variables configured${C_RESET}"
        log_warning "Missing: ${C_YELLOW}${missing_vars[*]}${C_RESET}"
        log_dim "Run the installer to configure missing variables"
    fi
}

verify_scripts() {
    log_step "Verifying script files..."
    
    local scripts=("newProject.sh" "libft.sh" "compiler.sh" "gitignore.sh" "updateLibft.sh")
    local found=0
    local missing=()
    
    for script in "${scripts[@]}"; do
        if [[ -f "${INSTALL_DIR}/src/${script}" ]]; then
            ((found++)) || true
        else
            missing+=("$script")
        fi
    done
    
    if [[ ${#missing[@]} -eq 0 ]]; then
        log_success "All ${C_CYAN}${found}${C_RESET}${C_WHITE} scripts present${C_RESET}"
    else
        log_warning "${C_CYAN}${found}${C_RESET}${C_WHITE}/${#scripts[@]} scripts present${C_RESET}"
        for m in "${missing[@]}"; do
            log_dim "${S_CROSS} Missing: ${m}"
        done
    fi
}

show_completion_message() {
    echo -e "\n  ${C_DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}\n"
    echo -e "  ${C_GREEN}${C_BOLD}${S_ROCKET} Update Complete!${C_RESET}\n"
    
    echo -e "  ${C_WHITE}Available commands:${C_RESET}"
    echo -e "    ${C_CYAN}npro${C_RESET}    ${C_DIM}${S_ARROW}${C_RESET} Create a new project"
    echo -e "    ${C_CYAN}alibft${C_RESET}  ${C_DIM}${S_ARROW}${C_RESET} Add libft to project"
    echo -e "    ${C_CYAN}acomp${C_RESET}   ${C_DIM}${S_ARROW}${C_RESET} Compile project"
    echo -e "    ${C_CYAN}agit${C_RESET}    ${C_DIM}${S_ARROW}${C_RESET} Generate .gitignore"
    echo -e "    ${C_CYAN}ulibft${C_RESET}  ${C_DIM}${S_ARROW}${C_RESET} Update libft"
    echo ""
    
    echo -e "  ${C_DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}\n"
}

# ─────────────────────────────────────────────────────────────────────────────────
# MAIN
# ─────────────────────────────────────────────────────────────────────────────────

main() {
    local original_dir
    original_dir="$(pwd)"
    
    clear
    show_banner
    
    check_installation
    pull_updates
    verify_scripts
    verify_aliases
    verify_exports
    
    cd "$original_dir" || true
    
    show_completion_message

    # Restart shell
    exec "$SHELL"
}

main "$@"
