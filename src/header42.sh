#!/bin/bash
#
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                          42 HEADER GENERATOR                                 ║
# ║                                                                              ║
# ║  Generates 42-style headers for any file type                                ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
#
# Usage: 
#   source header42.sh && generate_42_header "filename" ["user"] ["email"] ["date"]
#   OR run directly: ./header42.sh filename [user] [email] [date]

set -euo pipefail

# ─────────────────────────────────────────────────────────────────────────────────
# ASCII ART (right side of header)
# ─────────────────────────────────────────────────────────────────────────────────

readonly HEADER_ASCII=(
    "        :::      ::::::::"
    "      :+:      :+:    :+:"
    "    +:+ +:+         +:+  "
    "  +#+  +:+       +#+     "
    "+#+#+#+#+#+   +#+        "
    "     #+#    #+#          "
    "    ###   ########.fr    "
)

# ─────────────────────────────────────────────────────────────────────────────────
# COMMENT STYLES BY FILE EXTENSION
# ─────────────────────────────────────────────────────────────────────────────────

# Returns: "start end fill" for the comment style
get_comment_style() {
    local filename="$1"
    local ext="${filename##*.}"
    
    # Handle files without extension (like Makefile)
    [[ "$filename" == "$ext" ]] && ext="$filename"
    
    case "$ext" in
        # C/C++ family
        c|h|cc|hh|cpp|hpp|cxx|hxx|c++|h++)
            echo "/* */ *"
            ;;
        # Web markup
        htm|html|xml|xhtml|svg)
            echo "<!-- --> *"
            ;;
        # JavaScript/TypeScript
        js|ts|jsx|tsx|mjs|cjs)
            echo "// // *"
            ;;
        # LaTeX
        tex|sty|cls)
            echo "% % *"
            ;;
        # OCaml family
        ml|mli|mll|mly)
            echo "(* *) *"
            ;;
        # Vim
        vim|vimrc)
            echo "\" \" *"
            ;;
        # Lisp/Emacs
        el|lisp|scm|clj)
            echo "; ; *"
            ;;
        # Fortran
        f90|f95|f03|f08|f|for)
            echo "! ! /"
            ;;
        # CSS
        css|scss|sass|less)
            echo "/* */ *"
            ;;
        # SQL
        sql)
            echo "-- -- *"
            ;;
        # Lua
        lua)
            echo "-- -- *"
            ;;
        # Ruby
        rb|ruby)
            echo "# # *"
            ;;
        # Rust
        rs)
            echo "// // *"
            ;;
        # Go
        go)
            echo "// // *"
            ;;
        # Default: Shell/Makefile/Python style
        *)
            echo "# # *"
            ;;
    esac
}

# ─────────────────────────────────────────────────────────────────────────────────
# HEADER GENERATOR
# ─────────────────────────────────────────────────────────────────────────────────

generate_42_header() {
    local filename="${1:-Makefile}"
    local user="${2:-${USER:-$(whoami)}}"
    local mail="${3:-${MAIL:-$user@student.42.fr}}"
    local date="${4:-$(date +"%Y/%m/%d %H:%M:%S")}"
    
    # Get comment style components
    local style start end fill
    style=$(get_comment_style "$filename")
    read -r start end fill <<< "$style"
    
    # Constants
    local linelen=80
    local marginlen=5
    local asciiart_len=${#HEADER_ASCII[0]}
    local contentlen=$((linelen - (3 * marginlen - 1) - asciiart_len))
    
    # Calculate margins
    local lmargin rmargin midgap
    lmargin=$(printf '%*s' $((marginlen - ${#start})) '')
    rmargin=$(printf '%*s' $((marginlen - ${#end})) '')
    midgap=$(printf '%*s' $((marginlen - 1)) '')
    
    local left="${start}${lmargin}"
    local right="${rmargin}${end}"
    
    # Trim values to fit
    local trimlogin="${user:0:9}"
    local trimemail="${mail:0:$((contentlen - 16))}"
    local trimfile="${filename:0:$contentlen}"
    
    # Generate separator line
    local fillcount=$((linelen - 2 - ${#start} - ${#end}))
    local bigline="${start} $(printf '%*s' $fillcount '' | tr ' ' "$fill") ${end}"
    
    # Generate empty line
    local emptycount=$((linelen - ${#start} - ${#end}))
    local emptyline="${start}$(printf '%*s' $emptycount '')${end}"
    
    # Content line generator
    _pad_content() {
        local text="$1"
        local ascii_idx="$2"
        local padlen=$((contentlen - ${#text}))
        printf "%s%s%*s%s%s%s\n" "$left" "$text" "$padlen" "" "$midgap" "${HEADER_ASCII[$ascii_idx]}" "$right"
    }
    
    # Build content lines
    local byline="By: ${trimlogin} <${trimemail}>"
    local createdline="Created: ${date} by ${trimlogin}"
    local updatedline="Updated: ${date} by ${trimlogin}"
    
    # Output header
    echo "$bigline"
    echo "$emptyline"
    _pad_content "" 0
    _pad_content "$trimfile" 1
    _pad_content "" 2
    _pad_content "$byline" 3
    _pad_content "" 4
    _pad_content "$createdline" 5
    _pad_content "$updatedline" 6
    echo "$emptyline"
    echo "$bigline"
}

# ─────────────────────────────────────────────────────────────────────────────────
# DIRECT EXECUTION
# ─────────────────────────────────────────────────────────────────────────────────

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [[ $# -lt 1 ]]; then
        echo "Usage: $0 <filename> [user] [email] [date]"
        echo ""
        echo "Generates a 42-style header for the given file type."
        echo ""
        echo "Examples:"
        echo "  $0 main.c"
        echo "  $0 Makefile john john@student.42.fr"
        exit 1
    fi
    generate_42_header "$@"
fi
