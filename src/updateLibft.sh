#!/bin/bash
#
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                           42 LIBFT UPDATER                                   ║
# ║                                                                              ║
# ║  Push local libft changes back to your repository                            ║
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

validate_environment() {
    # Check repo URL
    if [[ -z "$REPO_URL" ]]; then
        log_error "LIBFT_REPO_URL is not set"
        log_dim "Set it in your environment:"
        log_dim "export LIBFT_REPO_URL=\"git@github.com:user/libft.git\""
        exit 1
    fi
    
    # Check local files exist
    local missing=()
    
    [[ ! -d "$LIBFT_DIR" ]] && missing+=("libft/")
    [[ ! -f "$INCLUDE_DIR/libft.h" ]] && missing+=("include/libft.h")
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Required files not found in $(pwd):"
        for m in "${missing[@]}"; do
            log_dim "${S_CROSS} $m"
        done
        exit 1
    fi
}

# ─────────────────────────────────────────────────────────────────────────────────
# UPDATE PROCESS
# ─────────────────────────────────────────────────────────────────────────────────

update_libft() {
    mini_banner "Libft Update" "$S_ROCKET"
    
    validate_environment
    
    log_dim "Source: Local project"
    log_dim "Target: $REPO_URL"
    
    # Create temp directory for clone
    local clone_dir
    clone_dir="$(mktemp -d)" || { log_error "Failed to create temp directory"; exit 1; }
    trap "rm -rf '$clone_dir'" EXIT
    
    # Clone repository
    log_info "Cloning libft repository..."
    git clone --recursive "$REPO_URL" "$clone_dir" > /dev/null 2>&1 &
    local pid=$!
    spinner $pid "Downloading..."
    wait $pid || { log_error "Failed to clone repository"; exit 1; }
    
    # Copy local files to clone
    log_info "Copying local changes..."
    
    mkdir -p "$clone_dir/include"
    mkdir -p "$clone_dir/libft"
    
    cp "$INCLUDE_DIR/libft.h" "$clone_dir/include/libft.h" || { log_error "Failed to copy libft.h"; exit 1; }
    rm -rf "$clone_dir/libft"
    cp -r "$LIBFT_DIR" "$clone_dir/libft" || { log_error "Failed to copy libft sources"; exit 1; }
    
    # Get commit message
    echo ""
    local commit_msg
    read_input "Commit message" commit_msg "📝"
    
    # Stage and check for changes
    pushd "$clone_dir" > /dev/null
    
    git add include/libft.h libft > /dev/null 2>&1 || { log_error "Failed to stage changes"; popd > /dev/null; exit 1; }
    
    if git diff --cached --quiet; then
        log_warning "No changes detected"
        log_dim "Your local libft matches the repository"
        popd > /dev/null
        return 0
    fi
    
    # Show what changed
    local files_changed
    files_changed=$(git diff --cached --name-only | wc -l)
    log_info "Files changed: ${C_CYAN}${files_changed}${C_RESET}"
    
    # Commit
    log_info "Committing changes..."
    git commit -m "$commit_msg" > /dev/null 2>&1 || { log_error "Failed to commit"; popd > /dev/null; exit 1; }
    
    local commit_hash
    commit_hash=$(git rev-parse --short HEAD)
    
    # Push
    log_info "Pushing to remote..."
    git push > /dev/null 2>&1 &
    pid=$!
    spinner $pid "Uploading..."
    wait $pid || { log_error "Failed to push. Please push manually."; popd > /dev/null; exit 1; }
    
    popd > /dev/null
    
    echo ""
    divider_light
    echo ""
    log_success "Libft updated successfully!"
    log_dim "Commit: $commit_hash - $commit_msg"
}

# ─────────────────────────────────────────────────────────────────────────────────
# MAIN
# ─────────────────────────────────────────────────────────────────────────────────

main() {
    update_libft
}

main "$@"
