#!/bin/bash
#
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                           42 LIBFT UPDATER                                   ║
# ║                                                                              ║
# ║  Push local libft changes back to your repository                            ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

set -euo pipefail

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# Source common library
if [[ -f "$SCRIPT_DIR/common.sh" ]]; then
    source "$SCRIPT_DIR/common.sh"
else
    echo "Error: common.sh not found" >&2
    exit 1
fi

REPO_URL="${LIBFT_REPO_URL:-}"
PROJECT_DIR="$(pwd)"
LIBFT_DIR="$PROJECT_DIR/libft"
INCLUDE_DIR="$PROJECT_DIR/include"

validate_environment() {
    if [[ -z "$REPO_URL" ]]; then
        log_error "LIBFT_REPO_URL is not set"
        log_dim "Set it in your environment:"
        log_dim "export LIBFT_REPO_URL=\"git@github.com:user/libft.git\""
        exit 1
    fi

    local missing=()
    [[ ! -d "$LIBFT_DIR" ]] && missing+=("libft/")
    [[ ! -d "$INCLUDE_DIR" ]] && missing+=("include/")

    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Required files not found in $(pwd):"
        for m in "${missing[@]}"; do
            log_dim "${S_CROSS} $m"
        done
        exit 1
    fi
}

# copy-if-different: copy src -> target (absolute), and stage relative path in repo
copy_if_different() {
    local src="$1"
    local target="$2"
    local rel_target="${target#$clone_dir/}"

    if [[ ! -f "$target" ]]; then
        mkdir -p "$(dirname "$target")"
        cp "$src" "$target" || { log_error "Failed to copy $src -> $target"; return 1; }
        git add -- "$rel_target" > /dev/null 2>&1 || { log_error "Failed to git add $rel_target"; return 1; }
        log_info "Added new file: ${C_CYAN}${rel_target}${C_RESET}"
        return 0
    fi

    if ! cmp -s "$src" "$target"; then
        cp "$src" "$target" || { log_error "Failed to copy $src -> $target"; return 1; }
        git add -- "$rel_target" > /dev/null 2>&1 || { log_error "Failed to git add $rel_target"; return 1; }
        log_info "Updated: ${C_CYAN}${rel_target}${C_RESET}"
    else
        log_dim "Unchanged: ${C_CYAN}${rel_target}${C_RESET}"
    fi
}

update_libft() {
    mini_banner "Libft Update" "$S_ROCKET"

    validate_environment

    log_dim "Source: Local project"
    log_dim "Target: $REPO_URL"

    local clone_dir
    clone_dir="$(mktemp -d)" || { log_error "Failed to create temp directory"; exit 1; }
    trap "rm -rf '$clone_dir'" EXIT

    log_info "Cloning libft repository..."
    git clone --recursive "$REPO_URL" "$clone_dir" > /dev/null 2>&1 &
    local pid=$!
    spinner $pid "Downloading..."
    wait $pid || { log_error "Failed to clone repository"; exit 1; }

    log_info "Preparing to compare and copy changed files..."

    pushd "$clone_dir" > /dev/null

    # 1) Handle include/libft.h only (no other .h)
    if [[ -f "$INCLUDE_DIR/libft.h" ]]; then
        src_header="$INCLUDE_DIR/libft.h"
        basename_header="$(basename "$src_header")"
        # find matches by basename in cloned repo
        mapfile -d $'\0' -t matches < <(find "$clone_dir" -type f -name "$basename_header" -print0 2>/dev/null || true)
        if [[ ${#matches[@]} -gt 0 ]]; then
            # pick the shallowest match (shortest path)
            best_match="$(printf "%s\n" "${matches[@]}" | awk '{ print length, $0 }' | sort -n | cut -d' ' -f2- | head -n1)"
            copy_if_different "$src_header" "$best_match"
        else
            rel="${src_header#$PROJECT_DIR/}"
            target="$clone_dir/$rel"
            copy_if_different "$src_header" "$target"
        fi
    fi

    # 2) Handle files in libft/ but exclude any .h files (only copy sources)
    while IFS= read -r -d '' src; do
        basename="$(basename "$src")"
        mapfile -d $'\0' -t matches < <(find "$clone_dir" -type f -name "$basename" -print0 2>/dev/null || true)
        if [[ ${#matches[@]} -gt 0 ]]; then
            best_match="$(printf "%s\n" "${matches[@]}" | awk '{ print length, $0 }' | sort -n | cut -d' ' -f2- | head -n1)"
            copy_if_different "$src" "$best_match"
        else
            rel="${src#$PROJECT_DIR/}"
            target="$clone_dir/$rel"
            copy_if_different "$src" "$target"
        fi
    done < <(find "$LIBFT_DIR" -type f ! -name '*.h' -print0 2>/dev/null)

    # Check for staged changes
    if git diff --cached --quiet; then
        log_warning "No changes detected"
        log_dim "Your local libft matches the repository"
        popd > /dev/null
        return 0
    fi

    local files_changed
    files_changed=$(git diff --cached --name-only | wc -l)
    log_info "Files changed: ${C_CYAN}${files_changed}${C_RESET}"

    # Get commit message
    echo ""
    local commit_msg
    read_input "Commit message" commit_msg "📝"

    log_info "Committing changes..."
    git commit -m "$commit_msg" > /dev/null 2>&1 || { log_error "Failed to commit"; popd > /dev/null; exit 1; }

    local commit_hash
    commit_hash=$(git rev-parse --short HEAD)

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

main() {
    update_libft
}

main "$@"