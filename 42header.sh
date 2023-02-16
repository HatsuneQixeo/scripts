
function ft_fileisc()
{
	# Extract the suffix, saving any character beyond . letter
	suffix=${1##*.}
	return $($([ "$suffix" == 'c' ] || [ "$suffix" == 'h' ]) && ! [ -d "$1" ])
}

function header_echo()
{
	echo 42header: "$@"
}

# Open the file in Vim and apply the header
function ft_update_addheader()
{
	vim -e "$1" -c "Stdheader" -c "wq" > /dev/null
	return $?
}

function ft_update()
{
	dir="$1"
	if ! [ -e "$dir" ]
	then
		header_echo file not exist: $dir
		return
	fi
	# Update if the given path is a source file
	if ft_fileisc "$dir"
	then
		ft_update_addheader "$dir"
		header_echo "$dir"
	fi
	# Returns if the given path is not a directory
	if ! [ -d "$dir" ]
	then
		return
	fi
	# Get the list of files in the specified directory
	arr_files="$(find "$dir" -name "*.c") $(find "$dir" -name "*.h")"
	files_updated=""
	# Loop through the files in the directory
	for file in $arr_files
	do
		# Exclude files that are not .c or .h suffix
		# if ! ft_fileisc "$file"
		# then
		# 	continue ;
		# fi
		ft_update_addheader "$1/$file"
		files_updated+="$file	"
		# Append the valid argument
		
	done
	if [ -n "$files_updated" ]
	then
		header_echo "$dir"
		for file in $files_updated
		do
			echo "	$file"
		done
	fi
}

# Checking the argc
if [ $# -eq 0 ]
then
	args="$(find . -name "*.c") $(find . -name "*.h")"
else
	args="$@"
fi

# Iterate through every given arguments
for dir in $args
do
	ft_update "$dir"
done
# $(find "$dir" -mindepth 1 -maxdepth 1)