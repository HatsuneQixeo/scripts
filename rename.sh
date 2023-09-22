if [ $# -lt 3 ]
then
	echo "Usage: $0 <pattern> <replacement> <filename>"
	exit 1
fi

pattern=$1
replacement=$2
shift 2

for path in $@
do
	newname="${path//$pattern/$replacement}"
	if [ "$path" = "$newname" ]
	then
		echo "source file has the same name as destination file: $path" >&2
	elif ! [ -e "$path" ]
	then
		echo "source file does not exists: $path" >&2
	elif [ -e "$newname" ]
	then
		echo "destination file exists: $newname" >&2
	else
		mv "$path" "$newname" && echo "$path -> $newname"
	fi
done
