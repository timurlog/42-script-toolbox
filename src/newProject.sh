#!/bin/bash
#
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                           42 NEW PROJECT CREATOR                             ║
# ║                                                                              ║
# ║  Quickly scaffold a new 42 project with all essentials                       ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

set -euo pipefail

# ─────────────────────────────────────────────────────────────────────────────────
# CONFIGURATION
# ─────────────────────────────────────────────────────────────────────────────────

SCRIPT_DIR="$HOME/.script/src"
WORKING_DIR="$(pwd)"

# ─────────────────────────────────────────────────────────────────────────────────
# SETUP
# ─────────────────────────────────────────────────────────────────────────────────

# Source common library
if [[ -f "$SCRIPT_DIR/common.sh" ]]; then
    source "$SCRIPT_DIR/common.sh"
else
    echo "Error: common.sh not found in $SCRIPT_DIR" >&2
    exit 1
fi

# ─────────────────────────────────────────────────────────────────────────────────
# BANNER
# ─────────────────────────────────────────────────────────────────────────────────

show_banner() {
    echo -e "\n${C_CYAN}${C_BOLD}"
    cat << 'EOF'
       _  __             ___             _         __ 
      / |/ /__ _    __  / _ \_______    (_)__ ____/ /_
     /    / -_) |/|/ / / ___/ __/ _ \  / / -_) __/ __/
    /_/|_/\__/|__,__/ /_/  /_/  \___/_/ /\__/\__/\__/ 
                                   |___/              
EOF
    echo -e "${C_RESET}"
    divider
}

# ─────────────────────────────────────────────────────────────────────────────────
# VALIDATION
# ─────────────────────────────────────────────────────────────────────────────────

check_dependencies() {
    log_step "Checking dependencies..."
    
    local required=("libft.sh" "compiler.sh" "gitignore.sh" "common.sh")
    local missing=()
    
    for script in "${required[@]}"; do
        if [[ ! -f "$SCRIPT_DIR/$script" ]]; then
            missing+=("$script")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Missing required scripts:"
        for m in "${missing[@]}"; do
            log_dim "${S_CROSS} $m"
        done
        log_info "Please run the installer or updater first."
        exit 1
    fi
    
    log_success "All dependencies found"
}

# ─────────────────────────────────────────────────────────────────────────────────
# PROJECT CREATION
# ─────────────────────────────────────────────────────────────────────────────────

get_project_info() {
    log_step "Project Information"
    
    read_input "Project name" PROJECT_NAME "$S_FOLDER"
    
    # Check if directory exists
    if [[ -d "$WORKING_DIR/$PROJECT_NAME" ]]; then
        log_error "Directory '${C_CYAN}${PROJECT_NAME}${C_RED}' already exists!"
        exit 1
    fi
    
    PROJECT_PATH="$WORKING_DIR/$PROJECT_NAME"
    log_dim "Location: $PROJECT_PATH"
}

init_repository() {
    log_step "Repository Setup"
    
    if ask_yes_no "Clone from existing repository?" "n"; then
        local repo_url
        read_input "Repository URL" repo_url "$S_LINK"
        
        log_info "Cloning repository..."
        git clone --recursive "$repo_url" "$PROJECT_PATH" > /dev/null 2>&1 &
        local pid=$!
        spinner $pid "Downloading..."
        wait $pid || { log_error "Failed to clone repository"; exit 1; }
        
        log_success "Repository cloned"
    else
        log_info "Initializing new repository..."
        git init "$PROJECT_PATH" > /dev/null 2>&1 || { log_error "Failed to initialize repository"; exit 1; }
        log_success "Repository initialized"
    fi
    
    cd "$PROJECT_PATH" || { log_error "Cannot access project directory"; exit 1; }
}

setup_project_structure() {
    log_step "Project Structure"
    
    # Gitignore
    log_info "Creating .gitignore..."
    bash "$SCRIPT_DIR/gitignore.sh" > /dev/null 2>&1 || { log_error "Failed to create .gitignore"; exit 1; }
    
    # Compiler/Makefile
    log_info "Setting up build system..."
    bash "$SCRIPT_DIR/compiler.sh" || { log_error "Failed to setup compiler"; exit 1; }
    
    # Source folder
    if ask_yes_no "Create src/ folder?" "y"; then
        mkdir -p src
        log_success "Created ${C_CYAN}src/${C_RESET}"
    fi
    
    # Include folder
    if ask_yes_no "Create include/ folder?" "y"; then
        mkdir -p include
        log_success "Created ${C_CYAN}include/${C_RESET}"
    fi
}

setup_libft() {
    log_step "Library Setup"
    
    if ask_yes_no "Initialize libft in this project?" "y"; then
        bash "$SCRIPT_DIR/libft.sh" || { log_error "Failed to initialize libft"; exit 1; }
    else
        log_dim "Skipping libft"
    fi
}

setup_readme() {
    log_step "README Setup"

    if ask_yes_no "Create a README.md file?" "y"; then
        cat << EOF > "$PROJECT_PATH/README.md"
*This project has been created as part of the 42 curriculum by tilogie.*

# $PROJECT_NAME

## Description
A brief overview of the project, its goal, and what it does.

## Instructions
How to compile, install, and/or run the project. Add any relevant commands or steps here.

## Resources
- Classic references (documentation, articles, tutorials, etc.)
- Description of how AI was used: specify for which tasks and which parts of the project.

<!-- Add additional sections as needed (usage examples, features, technical choices, etc.) -->
EOF
        log_success "Created ${C_CYAN}README.md${C_RESET}"
    else
        log_dim "Skipping README.md"
    fi
}

initial_commit() {
    log_step "Initial Commit"
    
    git add . > /dev/null 2>&1 || { log_error "Failed to stage files"; exit 1; }
    git commit -m "🎉 Initial project setup" > /dev/null 2>&1 || { log_error "Failed to commit"; exit 1; }
    
    local commit_hash
    commit_hash=$(git rev-parse --short HEAD)
    log_success "Committed: ${C_CYAN}${commit_hash}${C_RESET} - Initial project setup"
}

show_summary() {
    echo ""
    divider
    echo ""
    echo -e "  ${C_GREEN}${C_BOLD}${S_ROCKET} Project Created Successfully!${C_RESET}"
    echo ""
    echo -e "  ${C_WHITE}Project:${C_RESET}  ${C_CYAN}${PROJECT_NAME}${C_RESET}"
    echo -e "  ${C_WHITE}Location:${C_RESET} ${C_DIM}${PROJECT_PATH}${C_RESET}"
    echo ""
    
    # Show structure
    echo -e "  ${C_WHITE}Structure:${C_RESET}"
    local items
    items=$(ls -1A 2>/dev/null | head -10)
    while IFS= read -r item; do
        if [[ -d "$item" ]]; then
            echo -e "    ${C_CYAN}${S_FOLDER}${C_RESET} ${item}/"
        else
            echo -e "    ${C_DIM}${S_DOT}${C_RESET} ${item}"
        fi
    done <<< "$items"
    
    echo ""
    echo -e "  ${C_YELLOW}${S_STAR}${C_RESET} ${C_WHITE}Next steps:${C_RESET}"
    echo -e "    ${C_DIM}cd ${PROJECT_NAME}${C_RESET}"
    echo -e "    ${C_DIM}# Start coding!${C_RESET}"
    echo ""
    divider
    echo ""
}

# ─────────────────────────────────────────────────────────────────────────────────
# MAIN
# ─────────────────────────────────────────────────────────────────────────────────

main() {
    clear
    show_banner
    
    check_dependencies
    get_project_info
    init_repository
    setup_project_structure
    setup_libft
    setup_readme
    initial_commit
    
    show_summary
}

main "$@"
