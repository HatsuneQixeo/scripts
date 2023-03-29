#!/bin/bash

if [ $# -ne 2 ]
then
	echo "Bad Arguments"
	exit 1
fi

classDir="$1"
className="$(basename $1)"
newClassName="$2"
newClassDir="$(dirname $1)/$newClassName"

function classSed()
{
	local	upperClassName="$(tr [:lower:] [:upper:] <<< "$className")"
	local	upperNewClassName="$(tr [:lower:] [:upper:] <<< "$newClassName")"
	local	oldIFS=$IFS
	IFS=''

	while read line
	do
		if [ -n "$(grep "$upperClassName" <<< "$line")" ]
		then
			echo "${line//$upperClassName/$upperNewClassName}"
		else
			echo "${line//$className/$newClassName}"
		fi
	done
	IFS=$oldIFS
}

mkdir -p "$newClassDir"
< "$classDir/$className.cpp" classSed > "$newClassDir/$newClassName.cpp"
< "$classDir/$className.hpp" classSed > "$newClassDir/$newClassName.hpp"
