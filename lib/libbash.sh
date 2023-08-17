function getResponse()
{
	local	response
	# -q doesn't work in bash, but -n 1 doesn't return immediately in zsh
	echo -n "$@ [y/n]: " >&2 && read -q response
	# status is actually $?, so I gotta use another name, even if I declared it locally
	local	STATUS=$?

	echo >&2
	# Has to write = instead of == because zsh sucks.
	# Ew, I can't stand it as C programmer.
	# And comparison in zsh is case insensitive too, oh my miku.
	[ $STATUS -eq 0 ] && [ "$response" = 'y' ]
}

# Not tested
function ft_read()
{
	if [ $# -gt 2 ]
	then
		echo "Multiple arguments is not supported" >&2
	elif [ $# -ne 2 ]
	then
		echo "Usage: ft_read <varname> [prompt]" >&2
	else
		local	varname="$1"
		local	prompt="$2"
		local	value

		echo -n "$prompt: " >&2 && read value
		"$varname"="$value"
		return
	fi
	return 1
}
