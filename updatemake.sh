#!/bin/bash
function getResponse()
{
	local	response
	read -p "$@ [y/n]: " -n 1 response
	local	STATUS=$?

	echo >&2
	[ $STATUS -eq 0 ] && [ "$response" = 'y' ]
}

command="$1"

if [ $# -eq 1 ]
then
	dir="."
elif [ $# -eq 2 ]
then
	dir="$2"
else
	echo "Usage: updatemake.sh <command> [dir]"
	exit 1
fi

if ! getResponse "This shit is gonna overwrite every Makefiles it finds in $dir, are you sure?"
then
	echo "exit" >&2
	exit 0
elif [ ! -d "$dir" ]
then
	echo "Error: $dir is not a directory"
elif ! type "$command" > /dev/null
then
	echo "Error: $command is not a command"
else
	for file in $(find "$dir" -name "Makefile")
	do
		name="$(grep "NAME.*=" "$file")"
		# ## is trimming leading string
		# *= is matching anything before =
		# *[[space:]] is matching any amount of spaces after =
		name="${name##*=*[[:space:]]}"
		echo "updatemake: $file"
		(cd "$(dirname "$file")" && "$command" "$name") <<< "y"
	done
	exit 0
fi
exit 1
