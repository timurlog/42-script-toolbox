#!/bin/bash
#
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                           42 COMPILER SETUP                                  ║
# ║                                                                              ║
# ║  Interactive Makefile generator for C/C++ projects                           ║
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
    echo "Error: common.sh not found" >&2
    exit 1
fi

# ─────────────────────────────────────────────────────────────────────────────────
# VALIDATION
# ─────────────────────────────────────────────────────────────────────────────────

check_dependencies() {
    local required=("cMakefile.sh" "cppMakefile.sh")
    local missing=()
    
    for script in "${required[@]}"; do
        [[ ! -f "$SCRIPT_DIR/$script" ]] && missing+=("$script")
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Missing required scripts: ${missing[*]}"
        exit 1
    fi
}

# ─────────────────────────────────────────────────────────────────────────────────
# MAIN
# ─────────────────────────────────────────────────────────────────────────────────

main() {
    mini_banner "Compiler Setup" "$S_HAMMER"
    
    check_dependencies
    
    if ! ask_yes_no "Do you need a Makefile?" "y"; then
        log_dim "Skipping Makefile creation"
        return 0
    fi
    
    echo ""
    echo -e "  ${C_YELLOW}?${C_RESET} Select language:"
    echo -e "    ${C_CYAN}1)${C_RESET} C"
    echo -e "    ${C_CYAN}2)${C_RESET} C++"
    echo ""
    
    local choice
    while true; do
        echo -ne "  ${C_CYAN}${S_ARROW}${C_RESET} Choice ${C_DIM}[1-2]${C_RESET}: ${C_BOLD}"
        read -r choice || { echo -e "${C_RESET}"; return 1; }
        echo -ne "${C_RESET}"
        
        case "$choice" in
            1|c|C)
                bash "$SCRIPT_DIR/cMakefile.sh" || { log_error "Failed to create C Makefile."; exit 1; }
                log_success "C Makefile created"
                return 0
                ;;
            2|cpp|CPP|c++|C++)
                bash "$SCRIPT_DIR/cppMakefile.sh" || { log_error "Failed to create C++ Makefile."; exit 1; }
                log_success "C++ Makefile created"
                return 0
                ;;
            *)
                log_warning "Please enter 1 (C) or 2 (C++)"
                ;;
        esac
    done
}

main "$@"
