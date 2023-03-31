offset="$1"
where="$(basename $PWD)"

if ! [ $# -eq 1 ]
then
	echo "usage: exnext.sh {next/prev} (while inside exercise directory)" >&2
elif ! [[ "$where" =~ ex[0-9]{2} ]];
then
	echo "Not in exercise directory: $PWD" >&2
elif ! [[ "$offset" =~ ^[+-]?[0-9]+$ ]]
then
	echo "Invalid Argument: $offset" >&2
else
	destination="$(printf "ex%02d" $((${where:(-2)} + $offset)) )"
	echo "destination: $destination"
	cd "../$destination" && code -r . && return 0
fi
return 1