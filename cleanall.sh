#!/bin/bash
# Not gonna have any significant impact in terms of memory gained,
# just a tool for cleaning the mess left behind

function makeFClean
{
	# Find all Makefiles and run fclean
	for file in $(find . -name Makefile)
	do
		local	dir=$(dirname "$file")

		echo "Cleaning $dir"
		(make -C "$dir" fclean)
	done
}

function cleanRandom()
{
	local	files="$(find . -name a.out; find . -name '*.dSYM'; find . -name '.DS_Store')"

	[ -z "$files" ] && return 1

	echo "Remove:"
	read -p "$files [y/n] " -n 1
	echo

	if [[ "$REPLY" =~ ^[Yy]$ ]]
	then
		echo "Removing"
		echo "$files"
		rm -r $files
	fi
}

makeFClean
cleanRandom
