#!/bin/bash
#
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                        42 SCRIPT TOOLBOX INSTALLER                           ║
# ║                                                                              ║
# ║  A collection of productivity scripts for 42 students                        ║
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

readonly S_CHECK="✓"
readonly S_CROSS="✗"
readonly S_ARROW="→"
readonly S_DOT="•"
readonly S_STAR="★"
readonly S_GEAR="⚙"
readonly S_FOLDER="📁"
readonly S_LINK="🔗"
readonly S_USER="👤"
readonly S_MAIL="📧"
readonly S_ROCKET="🚀"

# ─────────────────────────────────────────────────────────────────────────────────
# LOGGING FUNCTIONS
# ─────────────────────────────────────────────────────────────────────────────────

log_header() {
    echo -e "\n${C_BLUE}${C_BOLD}┌─────────────────────────────────────────────────────────────┐${C_RESET}"
    echo -e "${C_BLUE}${C_BOLD}│${C_RESET}  $1"
    echo -e "${C_BLUE}${C_BOLD}└─────────────────────────────────────────────────────────────┘${C_RESET}\n"
}

log_info() {
    echo -e "  ${C_CYAN}${S_DOT}${C_RESET} ${C_WHITE}$1${C_RESET}"
}

log_success() {
    echo -e "  ${C_GREEN}${S_CHECK}${C_RESET} ${C_WHITE}$1${C_RESET}"
}

log_warning() {
    echo -e "  ${C_YELLOW}${S_STAR}${C_RESET} ${C_YELLOW}$1${C_RESET}"
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
    echo -e "          ${C_BOLD}${C_WHITE}T O O L B O X   I N S T A L L E R${C_RESET}"
    echo -e "          ${C_DIM}${C_GRAY}Version ${SCRIPT_VERSION}${C_RESET}\n"
    echo -e "  ${C_DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}\n"
}

# ─────────────────────────────────────────────────────────────────────────────────
# UTILITY FUNCTIONS
# ─────────────────────────────────────────────────────────────────────────────────

# Spinner animation for long operations
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

# Ask yes/no question with styled prompt
ask_yes_no() {
    local prompt="$1"
    local default="${2:-}"
    local answer

    while true; do
        echo -ne "  ${C_YELLOW}?${C_RESET} ${prompt} "
        if [[ "$default" == "y" ]]; then
            echo -ne "${C_DIM}[Y/n]${C_RESET} "
        elif [[ "$default" == "n" ]]; then
            echo -ne "${C_DIM}[y/N]${C_RESET} "
        else
            echo -ne "${C_DIM}[y/n]${C_RESET} "
        fi
        
        read -r answer || { log_error "Failed to read input."; return 2; }
        
        # Handle default values
        [[ -z "$answer" && -n "$default" ]] && answer="$default"
        
        case "${answer,,}" in
            y|yes) return 0 ;;
            n|no)  return 1 ;;
            *)     log_warning "Please enter 'y' or 'n'" ;;
        esac
    done
}

# Read user input with validation
read_input() {
    local prompt="$1"
    local var_name="$2"
    local icon="${3:-$S_ARROW}"
    local value=""

    while true; do
        echo -ne "  ${C_CYAN}${icon}${C_RESET} ${prompt}: ${C_BOLD}"
        read -r value || { echo -e "${C_RESET}"; log_error "Failed to read input."; return 1; }
        echo -ne "${C_RESET}"
        
        if [[ -n "${value// }" ]]; then
            eval "$var_name='$value'"
            return 0
        fi
        log_warning "This field cannot be empty."
    done
}

# Add alias if not exists (silent mode available)
add_alias() {
    local alias_name="$1"
    local alias_cmd="$2"
    local silent="${3:-false}"
    
    if ! grep -q "^alias ${alias_name}=" "$RC_FILE" 2>/dev/null; then
        printf "\nalias %s='%s'" "$alias_name" "$alias_cmd" >> "$RC_FILE"
        [[ "$silent" != "true" ]] && log_success "Added alias: ${C_CYAN}${alias_name}${C_RESET}"
        return 0
    fi
    return 1
}

# Handle environment variable configuration
configure_env_var() {
    local var_name="$1"
    local prompt="$2"
    local icon="$3"
    local current_value=""
    
    if grep -q "^${var_name}=" "$RC_FILE" 2>/dev/null; then
        current_value=$(grep "^${var_name}=" "$RC_FILE" | head -1 | cut -d '=' -f2-)
        
        if ask_yes_no "Update ${var_name}? ${C_DIM}(current: ${current_value})${C_RESET}" "n"; then
            local new_value
            read_input "$prompt" new_value "$icon" || return 1
            sed -i "s|^${var_name}=.*|${var_name}=${new_value}|" "$RC_FILE"
        fi
    else
        local new_value
        read_input "$prompt" new_value "$icon" || return 1
        printf "\n%s=%s" "$var_name" "$new_value" >> "$RC_FILE"
    fi
}

# Cleanup function for trap
cleanup() {
    [[ -n "${TEMP_DIR:-}" && -d "$TEMP_DIR" ]] && rm -rf "$TEMP_DIR"
}

# ─────────────────────────────────────────────────────────────────────────────────
# INSTALLATION STEPS
# ─────────────────────────────────────────────────────────────────────────────────

check_requirements() {
    log_step "Checking requirements..."
    
    local missing=()
    
    for cmd in git zsh; do
        if command -v "$cmd" &>/dev/null; then
            log_success "$cmd ${C_DIM}found${C_RESET}"
        else
            missing+=("$cmd")
            log_error "$cmd ${C_DIM}not found${C_RESET}"
        fi
    done
    
    if [[ ! -f "$RC_FILE" ]]; then
        log_warning ".zshrc not found, creating..."
        touch "$RC_FILE"
    fi
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Missing required tools: ${missing[*]}"
        exit 1
    fi
}

clone_repository() {
    log_step "Cloning repository..."
    
    TEMP_DIR="$(mktemp -d)" || { log_error "Failed to create temporary directory."; exit 1; }
    trap cleanup EXIT
    
    log_dim "Source: ${REPO_URL}"
    log_dim "Target: ${INSTALL_DIR}"
    
    # Clone with progress indication
    git clone --recursive "$REPO_URL" "$TEMP_DIR/.script" > /dev/null 2>&1 &
    local pid=$!
    spinner $pid "Downloading files..."
    wait $pid || { log_error "Failed to clone repository."; exit 1; }
    
    log_success "Repository cloned successfully"
}

install_files() {
    log_step "Installing files..."
    
    # Remove old installation
    if [[ -d "$INSTALL_DIR" ]]; then
        log_dim "Removing previous installation..."
        rm -rf "$INSTALL_DIR"
    fi
    
    # Copy new files
    cp -r "$TEMP_DIR/.script" "$HOME" || { log_error "Failed to copy files."; exit 1; }
    
    log_success "Files installed to ${C_CYAN}${INSTALL_DIR}${C_RESET}"
}

setup_aliases() {
    log_step "Setting up aliases..."
    
    # Using parallel arrays for compatibility (works in Bash 3.x+)
    local alias_names=("npro" "alibft" "acomp" "agit" "ulibft")
    local alias_cmds=(
        "bash ${INSTALL_DIR}/src/newProject.sh"
        "bash ${INSTALL_DIR}/src/libft.sh"
        "bash ${INSTALL_DIR}/src/compiler.sh"
        "bash ${INSTALL_DIR}/src/gitignore.sh"
        "bash ${INSTALL_DIR}/src/updateLibft.sh"
    )
    
    local added=0
    local skipped=0
    local i
    
    for i in "${!alias_names[@]}"; do
        if add_alias "${alias_names[$i]}" "${alias_cmds[$i]}" "true"; then
            ((added++)) || true
        else
            ((skipped++)) || true
        fi
    done
    
    if [[ $added -gt 0 && $skipped -gt 0 ]]; then
        log_success "Added ${C_CYAN}${added}${C_RESET}${C_WHITE} new alias(es), ${C_DIM}${skipped} already existed${C_RESET}"
    elif [[ $added -gt 0 ]]; then
        log_success "Added ${C_CYAN}${added}${C_RESET}${C_WHITE} alias(es)${C_RESET}"
    else
        log_success "All ${C_CYAN}${skipped}${C_RESET}${C_WHITE} aliases already configured${C_RESET}"
    fi
}

configure_user_settings() {
    log_step "Configuring user settings..."
    
    configure_env_var "USER" "Enter your 42 username" "$S_USER"
    configure_env_var "MAIL" "Enter your 42 email" "$S_MAIL"
    configure_env_var "LIBFT_REPO_URL" "Enter your libft repository URL" "$S_LINK"
    
    # Add export if not present
    if ! grep -Eq "^[[:space:]]*export.*(USER|MAIL|LIBFT_REPO_URL)" "$RC_FILE"; then
        printf "\nexport USER MAIL LIBFT_REPO_URL\n" >> "$RC_FILE"
    fi
    log_success "Environment variables configured"
}

show_completion_message() {
    echo -e "\n  ${C_DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}\n"
    echo -e "  ${C_GREEN}${C_BOLD}${S_ROCKET} Installation Complete!${C_RESET}\n"
    
    echo -e "  ${C_WHITE}Available commands:${C_RESET}"
    echo -e "    ${C_CYAN}npro${C_RESET}    ${C_DIM}${S_ARROW}${C_RESET} Create a new project"
    echo -e "    ${C_CYAN}alibft${C_RESET}  ${C_DIM}${S_ARROW}${C_RESET} Add libft to project"
    echo -e "    ${C_CYAN}acomp${C_RESET}   ${C_DIM}${S_ARROW}${C_RESET} Compile project"
    echo -e "    ${C_CYAN}agit${C_RESET}    ${C_DIM}${S_ARROW}${C_RESET} Generate .gitignore"
    echo -e "    ${C_CYAN}ulibft${C_RESET}  ${C_DIM}${S_ARROW}${C_RESET} Update libft"
    echo ""
    
    echo -e "  ${C_DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}\n"
}

# ─────────────────────────────────────────────────────────────────────────────────
# MAIN
# ─────────────────────────────────────────────────────────────────────────────────

main() {
    local original_dir
    original_dir="$(pwd)"
    
    clear
    show_banner
    
    check_requirements
    clone_repository
    install_files
    setup_aliases
    configure_user_settings
    
    # Return to original directory
    cd "$original_dir" || true
    
    show_completion_message
    
    # Restart shell
    exec "$SHELL"
}

main "$@"
