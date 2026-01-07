#!/bin/bash

# Define color codes for output messages
YELLOW="\033[1;33m"
RED="\033[0;91m"
GREEN="\033[1;32m"
BLUE="\033[0;94m"
MAGENTA="\033[0;95m"
RESET="\033[0m"

# Define project name
project_name=$(basename "$(pwd)") || { echo -e "${RED}Failed to get project name.${RESET}"; exit 1; }

# Check if project name is empty
if [[ -z "$project_name" ]]; then
    echo -e "${RED}Project name is empty.${RESET}"
    exit 1
fi

touch .gitignore || { echo -e "${RED}Failed to create .gitignore file.${RESET}"; exit 1; }

cat <<GIT_EOF > .gitignore
# ============================================
# 🎯 PROJET
# ============================================
$project_name

# ============================================
# 📦 C / C++
# ============================================
# Fichiers objets et binaires
*.o
*.obj
*.a
*.so
*.so.*
*.dylib
*.exe
*.out
*.elf
*.lib
*.dll

# Fichiers de compilation et de débogage
*.d
*.gcda
*.gcno
*.gcov
*.dSYM/

# Fichiers générés par Make/CMake
Makefile.in
config.h
config.log
config.status
CMakeCache.txt
CMakeFiles/
cmake_install.cmake
compile_commands.json
build/
out/

# Fichiers précompilés
*.gch
*.pch

# ============================================
# 🐍 PYTHON
# ============================================
# Byte-compiled / optimized / DLL files
__pycache__/
*.py[cod]
*\$py.class

# Virtual environments
venv/
env/
.venv/
.env/
ENV/

# Distribution / packaging
dist/
build/
*.egg-info/
*.egg
*.whl
.eggs/

# PyInstaller
*.manifest
*.spec

# Installer logs
pip-log.txt
pip-delete-this-directory.txt

# Unit test / coverage reports
htmlcov/
.tox/
.nox/
.coverage
.coverage.*
.cache
nosetests.xml
coverage.xml
*.cover
*.py,cover
.hypothesis/
.pytest_cache/
pytestdebug.log

# Jupyter Notebook
.ipynb_checkpoints

# mypy
.mypy_cache/
.dmypy.json
dmypy.json

# ============================================
# 🌐 WEBDEV FULLSTACK
# ============================================
# Node.js
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*
.pnpm-store/
package-lock.json
yarn.lock
pnpm-lock.yaml

# Builds
dist/
.next/
.nuxt/
.output/
.svelte-kit/
.turbo/

# Environment files
.env
.env.local
.env.development.local
.env.test.local
.env.production.local
.env*.local

# Cache
.cache/
.parcel-cache/
.eslintcache
.stylelintcache
*.tsbuildinfo

# Logs
logs/
*.log

# Static files build
public/build/
static/build/

# TypeScript
*.tsbuildinfo

# ============================================
# 🏫 CAMPUS 42
# ============================================
# Libft / libraries
libft/*.o
libft/*.a

# Norminette
*.norme

# Test files 42
test/
tests/
*_test.c
*_test

# 42 specific
.DS_Store
.Trash-*

# ============================================
# 💻 IDE / ÉDITEURS
# ============================================
# VSCode
.vscode/
*.code-workspace

# JetBrains (CLion, PyCharm, WebStorm)
.idea/
*.iml
*.ipr
*.iws

# Vim / Neovim
*.swp
*.swo
*.swn
*~
.netrwhist
Session.vim
.undodir/

# Emacs
*~
\#*\#
/.emacs.desktop
/.emacs.desktop.lock
*.elc
auto-save-list
tramp

# Sublime Text
*.sublime-workspace
*.sublime-project

# ============================================
# 🖥️ SYSTÈME
# ============================================
# macOS
.DS_Store
.AppleDouble
.LSOverride
._*
.Spotlight-V100
.Trashes

# Linux
*~
.fuse_hidden*
.directory
.Trash-*
.nfs*

# Windows
Thumbs.db
ehthumbs.db
Desktop.ini
\$RECYCLE.BIN/
*.cab
*.msi
*.msix
*.msm
*.msp
*.lnk

# ============================================
# 📁 DIVERS
# ============================================
# Résultats des tests
/test_output/
/test_results/

# Logs généraux
*.log

# Archives
*.tar
*.tar.gz
*.zip
*.rar
*.7z

# Fichiers temporaires
*.tmp
*.temp
*.bak
*.backup
GIT_EOF
