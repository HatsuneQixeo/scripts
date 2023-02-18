function ft_fileisc()
{
	# Extract the suffix, saving any character beyond . letter
	suffix=${1##*.}
	return $($([ "$suffix" == 'c' ] || [ "$suffix" == 'h' ]) && ! [ -d "$1" ])
}

function header_echo()
{
	echo "42header: $@"
}

# Open the file in Vim and apply the header
function apply_header()
{
	# Deadly bug with -e:
	#	It can freeze the whole script if the given file does not exist?
	#	or is it nonexist directory?
	vim -e "$1" -c "Stdheader" -c "wq" > /dev/null
	return $?
}

function apply_dir_headers()
{
	# Just to keep the display consistent
	dir="${1//\//}/"
	# Get the list of files in the specified directory
	arr_files="$(find "$dir" -name "*.c") $(find "$dir" -name "*.h")"
	# Return if nothing is found
	if [ -z "$arr_files" ]
	then
		return
	fi
	# Pattern substitution, ex: mikudir/miku.c mikudir/miku.h -> miku.c miku.h
	arr_files="${arr_files//$dir\//}"
	header_echo "$dir"
	for file in $arr_files
	do
		apply_header "$dir/$file" && echo "	$file"
	done
}

# Checking the argc
if [ $# -eq 0 ]
then
	args="$(find . -name "*.c") $(find . -name "*.h")"
else
	# potential bug?
	args="$@"
fi

for dir in $args
do
	# Update if the given path is a source file
	if ft_fileisc "$dir"
	then
		apply_header "$dir" && header_echo "$dir"
	elif [ -d "$dir" ]
	then
		apply_dir_headers "$dir"
	else
		header_echo "$dir: No such directory or file"
	fi
done
