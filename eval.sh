#!/bin/bash

VOGSPHERE_PREFIX="git@vogsphere.42kl.edu.my:vogsphere/intra-uuid"
EVAL_DIR="$EVAL"

function newdir()
{
	local	newdir

	read -p "New Directory Name: " newdir || return 1
	if ! [ -e "$newdir" ]
	then
		mkdir "$newdir" && cd "$newdir"
	elif [ -d "$newdir" ]
	then
		echo "Directory exist: $newdir"
		cd "$newdir"
	else
		echo "$newdir is a existing non directory file"
		return 1
	fi
	return $?
}

# Don't think I like the idea of getting index input,
# not to mention user also has to read the index even with clear destination
function projectdir()
{
	local	arr_dir=()

	cd "$EVAL_DIR"
	for dir in */
	do
		arr_dir+=("$dir")
	done
	local	length=${#arr_dir[@]}

	while true
	do
		echo "-1: New Directory"
		for (( i = 0; i < $length; i++ ))
		do
			printf "%2d: ${arr_dir[i]}\n" $i >&2
		done
		read -p "Directory Index: " index || return 1
		if ! [[ "$index" =~ ^-?[0-9]+$ ]]
		then
			echo -e $Red"Must be integer: $index"$Reset >&2
		elif [ $index -eq -1 ]
		then
			newdir
			return $?
		elif [ $index -ge $length ] || [ $index -lt 0 ]
		then
			echo -e $Red"Out of bound: $index"$Reset >&2
		else
			break
		fi
	done
	cd "${arr_dir[index]}"
}

projectdir &&
read -p "Link: " link || exit 1
if [ $(tr -cd '-' <<< "$link" | wc -c) -lt 8 ] || [[ "$link" != "$VOGSPHERE_PREFIX"* ]]
then
	echo "Does not recognize as vogsphere repo: $link"
	exit 1
fi
name="${link#*-*-*-*-*-*-*-*-}"

git clone "$link" "$name" && cd "./$name/" && code "."
