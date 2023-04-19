if [ $# -ne 2 ]
then
	echo "usage: showdiff.sh {start(00 || 01)} {classname}"
	exit 1
elif ! [[ "$1" =~ ^[0-9]+$ ]]
then
	echo "Invalid Start: $1"
	exit 1
fi

Reset='\033[0m'
Bold='\033[1m'
Underline='\033[4m'
Blinking='\033[5m'
Inverse='\033[7m'
Black='\033[30m'
Red='\033[31m'
Green='\033[32m'
Yellow='\033[33m'
Blue='\033[34m'
Magenta='\033[35m'
Cyan='\033[36m'
White='\033[37m'
B_Black='\033[40m'
B_Red='\033[41m'
B_Green='\033[42m'
B_Yellow='\033[43m'
B_Blue='\033[44m'
B_Magenta='\033[45m'
B_Cyan='\033[46m'
B_White='\033[47m'

startN=$1
startDir="ex$startN"
className="$2"

classPath="srcs/$className"

classSourceFile="$classPath/$className.cpp"
classHeaderFile="$classPath/$className.hpp"

sourceExHeader="$startDir/$classHeaderFile"
sourceExSource="$startDir/$classSourceFile"


function ft_showdiff()
{
	local	leftFile="$1"
	local	rightFile="$2"
	local	leftColouredFile="$Cyan$leftFile$Reset"
	local	rightColouredFile="$Cyan$rightFile$Reset"

	echo "--------------------------------------------------------------------------------"
	echo "Diff: $leftColouredFile : $rightColouredFile"
	difference="$(diff -y "$1" "$2")"
	status=$?
	if [ $status == 0 ]
	then
		echo $Green"No difference"$Reset
	elif [ $status == 1 ]
	then
		echo $Yellow"Difference"
		echo "$difference$Reset"
		printf "Overwrite $rightColouredFile(right) with $leftColouredFile(left)? [y/n/r(reverse)]"
		read -n 1 -r
		echo
		if [[ $REPLY =~ ^[Yy]$ ]]
		then
			cp "$leftFile" "$rightFile" &&
			echo $Green"Overwrite $rightColouredFile with $leftColouredFile"$Reset
		elif [[ $REPLY =~ ^[Rr]$ ]]
		then
			cp "$rightFile" "$leftFile" &&
			echo $Green"Overwrite $leftColouredFile with $rightColouredFile"$Reset
		else
			echo $Red"Cancelled"$Reset
		fi
	elif [ $status == 2 ]
	then
		echo $Red"File not Found"$Reset
	else
		echo $Red"Unknown Error"$Reset
	fi
	echo "--------------------------------------------------------------------------------"
	echo
}

for dir in ex*/
do
	[ ${dir:2:2} -eq $startN ] && continue
	
	ft_showdiff "$sourceExSource" "$dir$classSourceFile"
	ft_showdiff "$sourceExHeader" "$dir$classHeaderFile"
done
