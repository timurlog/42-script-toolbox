#!/bin/bash
#
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                           42 LIBFT INSTALLER                                 ║
# ║                                                                              ║
# ║  Clone and install your libft into the current project                       ║
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
# VARIABLES
# ─────────────────────────────────────────────────────────────────────────────────

REPO_URL="${LIBFT_REPO_URL:-}"
PROJECT_DIR="$(pwd)"
LIBFT_DIR="$PROJECT_DIR/libft"
INCLUDE_DIR="$PROJECT_DIR/include"

# ─────────────────────────────────────────────────────────────────────────────────
# VALIDATION
# ─────────────────────────────────────────────────────────────────────────────────

check_repo_url() {
    if [[ -z "$REPO_URL" ]]; then
        log_error "LIBFT_REPO_URL is not set"
        log_dim "Set it in your environment:"
        log_dim "export LIBFT_REPO_URL=\"git@github.com:user/libft.git\""
        exit 1
    fi
}

# ─────────────────────────────────────────────────────────────────────────────────
# INSTALLATION
# ─────────────────────────────────────────────────────────────────────────────────

install_libft() {
    mini_banner "Libft Installation" "$S_BOOK"
    
    check_repo_url
    
    log_dim "Source: $REPO_URL"
    log_dim "Target: $LIBFT_DIR"
    
    # Check for existing installation
    if [[ -d "$LIBFT_DIR" ]]; then
        log_warning "Libft already exists in this project"
        if ! ask_yes_no "Overwrite existing libft?" "n"; then
            log_dim "Installation cancelled"
            return 0
        fi
        rm -rf "$LIBFT_DIR"
    fi
    
    # Create temp directory
    local temp_dir
    temp_dir="$(mktemp -d)" || { log_error "Failed to create temp directory"; exit 1; }
    trap "rm -rf '$temp_dir'" EXIT
    
    # Clone repository
    log_info "Cloning libft repository..."
    git clone --recursive "$REPO_URL" "$temp_dir/libft" > /dev/null 2>&1 &
    local pid=$!
    spinner $pid "Downloading..."
    wait $pid || { log_error "Failed to clone repository"; exit 1; }
    
    # Copy files
    log_info "Installing files..."
    
    # Create directories
    mkdir -p "$LIBFT_DIR"
    mkdir -p "$INCLUDE_DIR"
    
    # Copy libft sources (excluding .git)
    if [[ -d "$temp_dir/libft/libft" ]]; then
        # Nested structure: repo/libft/
        cp -r "$temp_dir/libft/libft/"* "$LIBFT_DIR/" 2>/dev/null || true
    else
        # Flat structure: repo/
        find "$temp_dir/libft" -maxdepth 1 -name "*.c" -exec cp {} "$LIBFT_DIR/" \;
        find "$temp_dir/libft" -maxdepth 1 -name "*.h" -exec cp {} "$LIBFT_DIR/" \;
        [[ -f "$temp_dir/libft/Makefile" ]] && cp "$temp_dir/libft/Makefile" "$LIBFT_DIR/"
    fi
    
    # Copy header to include directory
    if [[ -f "$temp_dir/libft/include/libft.h" ]]; then
        cp "$temp_dir/libft/include/libft.h" "$INCLUDE_DIR/"
    elif [[ -f "$temp_dir/libft/libft.h" ]]; then
        cp "$temp_dir/libft/libft.h" "$INCLUDE_DIR/"
    elif [[ -f "$LIBFT_DIR/libft.h" ]]; then
        cp "$LIBFT_DIR/libft.h" "$INCLUDE_DIR/"
    fi
    
    # Count installed files
    local c_count h_count
    c_count=$(find "$LIBFT_DIR" -name "*.c" 2>/dev/null | wc -l)
    h_count=$(find "$LIBFT_DIR" "$INCLUDE_DIR" -name "*.h" 2>/dev/null | wc -l)
    
    log_success "Libft installed"
    log_dim "Files: ${c_count} .c, ${h_count} .h"
}

# ─────────────────────────────────────────────────────────────────────────────────
# MAIN
# ─────────────────────────────────────────────────────────────────────────────────

main() {
    install_libft
}

main "$@"
