function newscript()
{
	if [ $# -eq 0 ]
	then
		echo "Usage: newscript <scriptname>" >&2
		return 1
	fi
	for arg in "$@"
	do
		local	name="$arg.sh"

		touch "$name" && chmod +x "$name" && code "$name"
	done
}

function makeiter()
{
	for dir in ex*/
	do
		echo "make -C $dir $1" && make -C "$dir" $1
	done
}

function rmtilda()
{
	for arg in \~*
	do
		mv "$arg" "${arg/#~/}"
	done
}

function exiter()
{
	for dir in ex*/
	do
		echo "exiter: $dir: ($@)" && (cd "$dir" && $@)
		echo
	done
}
