function show_help
{
	<< EOF cat >&2
usage: exnext.sh {offset} [options] (while inside exercise directory)
options:
	new: Create a new exercise directory if there's no existing one
	dup: Invoke a new vscode window if there's no existing one
	cd: Do not invoke vscode
	help: Show this help
EOF
}

function getFlags()
{
	dup=false
	termonly=false
	for arg in "${@:2}"
	do
		# new is Copilot's ideas, quite intesting
		case "$arg" in
		"new")
			mkdir "$dest_path" 2>/dev/null || echo "Directory already exists: $destination" >&2
			;;
		"help")
			show_help
			return 1
			;;
		"dup")
			dup=true
			;;
		"cd")
			termonly=true
			;;
		*)
			echo "Invalid Argument: $arg" >&2
			show_help
			return 2
			;;
		esac
	done
}

offset="$1"
where="$(basename $PWD)"

if [ $# -eq 0 ]
then
	show_help
elif ! [[ "$where" =~ ex[0-9]{2} ]];
then
	echo "Not in exercise directory: $PWD" >&2
elif ! [[ "$offset" =~ ^[+-]?[0-9]+$ ]]
then
	echo "Invalid Offset: $offset" >&2
else
	# Increment/decrement from current exercise if there is given sign(+/-) for offset
	[[ ${offset:0:1} =~ ^[+-]$ ]] && offset=$((${where:(-2)} + $offset))

	# Set the destination directory
	if [ $offset -lt 0 ] || [ $offset -gt 99 ]
	then
		echo "Invalid Offset: $offset" >&2
		return 1
	fi
	destination="$(printf "ex%02d" $offset )"
	dest_path="../$destination"

	# Get Flags
	getFlags "$@" || return $(($? - 1))

	echo "destination: $destination"

	# Go to destination directory
	! cd "$dest_path" && return 1
	[ $termonly = true ] && return 0
	# Invoke vscode, default into replacing the current available window unless dup is specified
	code $([ $dup = false ] && echo '-r') . &&
	# Success return
	return 0
fi
return 1
