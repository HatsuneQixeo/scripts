function ft_fileisc()
{
	# Extract the suffix, saving every characters beyond the last '.' letter
	local	suffix=${1##*.}

	return $([ "$suffix" == 'c' ] || [ "$suffix" == 'h' ])
}

function header_echo()
{
	echo "42header: $@"
}

# Open the file in Vim and apply the header
function apply_header()
{
	local	file="$1"
	# Deadly bug with -e:
	#	It can freeze the whole script if the given file does not exist?
	#	or is it nonexist directory?
	if ! [ -e "$file" ]
	then
		header_echo "$file: No such directory or file (in apply_header)"
		return 1
	fi
	vim -e "$file" -c "Stdheader" -c "wq" > /dev/null
	return $?
}

function apply_dir_headers()
{
	# Just to keep the display consistent
	local	dir="${1//\//}"
	# Get the list of files in the specified directory
	local	arr_files="$(find "$dir" -name "*.c") $(find "$dir" -name "*.h")"
	# Return if nothing is found
	[ -z "$arr_files" ] && return
	# Pattern substitution, ex: mikudir/miku.c mikudir/miku.h -> miku.c miku.h
	arr_files="${arr_files//$dir\//}"
	header_echo "$dir/"
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

for path in $args
do
	if ! [ -e "$path" ]
	then
		header_echo "$path: No such directory or file"
	elif [ -d "$path" ]
	then
		apply_dir_headers "$path"
	elif ft_fileisc "$path"
	then
		apply_header "$path" && header_echo "$path"
	else
		header_echo "$path: Is not a c source file"
	fi
done
