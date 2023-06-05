#!/bin/bash

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

function main()
{
	if ! [ -e "$newClassDir" ]
	then
		mkdir "$newClassDir" || return 1
	fi
	< "$classDir/$className.cpp" classSed > "$newClassDir/$newClassName.cpp"
	< "$classDir/$className.hpp" classSed > "$newClassDir/$newClassName.hpp"
}

if [ $# -ne 2 ]
then
	echo "Bad Arguments"
	exit 1
fi

classDir="$1"
className="$(basename $1)"
newClassName="$2"
newClassDir="$(dirname $1)/$newClassName"

if ! [ -e "$classDir" ]
then
	echo "Class $className does not exist"
elif ! [ -e "$classDir/$className.cpp" ]
then
	echo "Class $className.cpp does not exist"
elif ! [ -e "$classDir/$className.hpp" ]
then
	echo "Class $className.hpp does not exist"
else
	main
	exit
fi

exit 1
