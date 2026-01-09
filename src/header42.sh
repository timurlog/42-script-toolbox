#!/bin/bash

set -euo pipefail

# Generates a 42 header for any file type
# Usage: source header42.sh && generate_42_header "filename" ["user"] ["email"] ["date"]

# ASCII art for the right side of the header
ASCIIART=(
	"        :::      ::::::::"
	"      :+:      :+:    :+:"
	"    +:+ +:+         +:+  "
	"  +#+  +:+       +#+     "
	"+#+#+#+#+#+   +#+        "
	"     #+#    #+#          "
	"    ###   ########.fr    "
)

# Get comment style based on file extension
get_comment_style() {
	local filename="$1"
	local ext="${filename##*.}"
	
	case "$ext" in
		c|h|cc|hh|cpp|hpp)
			echo "/* */ *"
			;;
		htm|html|xml)
			echo "<!-- --> *"
			;;
		js|ts)
			echo "// // *"
			;;
		tex)
			echo "% % *"
			;;
		ml|mli|mll|mly)
			echo "(* *) *"
			;;
		vim)
			echo "\" \" *"
			;;
		el|emacs)
			echo "; ; *"
			;;
		f90|f95|f03|f|for)
			echo "! ! /"
			;;
		*)
			# Default: shell/Makefile style
			echo "# # *"
			;;
	esac
}

# Generate 42 header
generate_42_header() {
	local filename="${1:-Makefile}"
	local user="${2:-${USER:-$(whoami)}}"
	local mail="${3:-${MAIL:-$user@student.42.fr}}"
	local date="${4:-$(date +"%Y/%m/%d %H:%M:%S")}"
	
	# Get comment style
	local style
	style=$(get_comment_style "$filename")
	local start end fill
	read -r start end fill <<< "$style"
	
	# Constants
	local linelen=80
	local marginlen=5
	local asciiart_len=${#ASCIIART[0]}
	local contentlen=$((linelen - (3 * marginlen - 1) - asciiart_len))
	
	# Helper functions
	local lmargin rmargin midgap
	lmargin=$(printf '%*s' $((marginlen - ${#start})) '')
	rmargin=$(printf '%*s' $((marginlen - ${#end})) '')
	midgap=$(printf '%*s' $((marginlen - 1)) '')
	
	local left="${start}${lmargin}"
	local right="${rmargin}${end}"
	
	# Trim functions
	local trimlogin="${user:0:9}"
	local trimemail="${mail:0:$((contentlen - 16))}"
	
	# Generate bigline
	local fillcount=$((linelen - 2 - ${#start} - ${#end}))
	local bigline="${start} $(printf '%*s' $fillcount '' | tr ' ' "$fill") ${end}"
	
	# Generate empty line
	local emptycount=$((linelen - ${#start} - ${#end}))
	local emptyline="${start}$(printf '%*s' $emptycount '')${end}"
	
	# Generate content lines
	pad_content() {
		local text="$1"
		local ascii_idx="$2"
		local padlen=$((contentlen - ${#text}))
		printf "%s%s%*s%s%s%s\n" "$left" "$text" "$padlen" "" "$midgap" "${ASCIIART[$ascii_idx]}" "$right"
	}
	
	# File line
	local trimfile="${filename:0:$contentlen}"
	
	# By line
	local byline="By: ${trimlogin} <${trimemail}>"
	
	# Date lines
	local createdline="Created: ${date} by ${trimlogin}"
	local updatedline="Updated: ${date} by ${trimlogin}"
	
	# Output header
	echo "$bigline"
	echo "$emptyline"
	pad_content "" 0
	pad_content "$trimfile" 1
	pad_content "" 2
	pad_content "$byline" 3
	pad_content "" 4
	pad_content "$createdline" 5
	pad_content "$updatedline" 6
	echo "$emptyline"
	echo "$bigline"
}

# If script is run directly (not sourced), generate header
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	generate_42_header "$@"
fi
