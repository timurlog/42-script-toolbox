# Changelog

## v1.1.0 - 2025-01-09

### ✨ Added
- **New commands:**
  - `shelp` - Interactive help system with detailed documentation for all commands
  - `sversion` - Display toolbox version and build information

- **New architecture:**
  - `common.sh` - Shared library with reusable functions, colors, symbols, and utilities
  - Centralized logging functions (`log_info`, `log_success`, `log_warning`, `log_error`, `log_step`, `log_dim`)
  - Unified input functions (`ask_yes_no`, `read_input`, `read_input_default`, `select_option`)
  - Git helper functions (`is_git_repo`, `git_branch`, `git_hash`, `git_clone_spinner`)
  - Spinner animation for long-running operations
  - Progress bar utility

### 🔄 Changed
- **Renamed all command aliases** for consistency:
  - `npro` → `snew` (new project)
  - `alibft` → `slib` (add libft)
  - `acomp` → `smake` (create makefile)
  - `agit` → `signore` (generate .gitignore)
  - `ulibft` → `spush` (push libft updates)
  - Added `supdate` alias for update script

- **Complete UI/UX overhaul:**
  - New ASCII art banners for all scripts
  - Modern colored output with emojis and symbols
  - Improved prompts with default values shown in brackets
  - Loading spinners during git operations
  - Clear step-by-step progress indicators
  - Better error messages with visual hierarchy

- **Improved `newProject.sh`:**
  - Modular function-based architecture
  - Option to clone existing repo OR initialize new one
  - Visual project structure summary on completion
  - Automatic initial commit with emoji (`🎉 Initial project setup`)
  - Better dependency checking

- **Improved `libft.sh`:**
  - Smart detection of libft repository structure (nested vs flat)
  - Automatic header copying to `include/` directory
  - File count summary after installation
  - Overwrite confirmation for existing installations

- **Improved `install.sh`:**
  - Requirements check (git, zsh) before installation
  - Spinner animation during clone
  - Silent alias addition with summary count
  - Smart environment variable handling (update existing vs add new)
  - Modern completion message with command reference

- **Improved `update.sh`:**
  - Commit count display when updates available
  - Script file verification
  - Alias verification and auto-fix for incorrect paths
  - Environment variable validation
  - Detailed status summary

### 🛠️ Technical Improvements
- All scripts now use `set -euo pipefail` for safer execution
- Consistent use of `readonly` for constants
- Proper cleanup with `trap` for temporary directories
- Better error handling throughout
- Modular code organization with clear section headers
- Documentation headers in all script files

### 📚 Documentation
- Updated README with new command names
- Added 3 new documented commands in command reference table

---

## v1.0.0 - 2025-01-08

### Added
- Initial release of 42 Script Toolbox
- `npro` command: Create new projects from templates with basic file initialization
- `alibft` command: Add libft library to current project
- `acomp` command: Generate project Makefile and compilation settings
- `agit` command: Add standard .gitignore to projects
- `ulibft` command: Update libft repository with local version
- Interactive installation script with user configuration (42 username, email, libft repo)
- Automatic update script for toolbox maintenance
- Support for C and C++ project templates
- Makefile generators for both C and C++ projects
- 42 header integration
- Comprehensive README with installation and usage instructions
- MIT License

### Features
- One-command installation via curl
- Persistent user configuration storage
- Libft repository structure validation
- Automated project scaffolding
- Build system generation
- Git integration helpers