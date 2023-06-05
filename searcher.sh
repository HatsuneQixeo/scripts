function work()
{
	local	DEFAULT_WORKSPACE="$CODE"

	if [ $# -eq 0 ]
	then
		echo "Opening the default workspace" && code "$DEFAULT_WORKSPACE"
		return
	fi
	for arg in "$@"
	do
		local	dirPath="$DEFAULT_WORKSPACE/$arg"

		if [ ! -e "$dirPath" ]
		then
			echo "$dirPath does not exist" >&2
		elif [ ! -d "$dirPath" ]
		then
			echo "$dirPath is not a directory" >&2
		else
			echo "Opening $dirPath" && code "$dirPath"
		fi
	done
}

function pdf()
{
	local	PDF_DIR="$PDF"

	if [ $# -eq 0 ]
	then
		echo "Opening the pdf directory" && open "$PDF_DIR"
		return
	fi
	for arg in "$@"
	do
		local	dirPath="$PDF_DIR/$arg.pdf"

		echo "Opening $dirPath" && open "$dirPath"
	done
}

function evalOpen()
{
	local	EVAL_DIR="$EVAL"

	if [ $# -eq 0 ]
	then
		echo "Opening the Eval directory" && code "$EVAL_DIR"
		return
	fi
	for arg in "$@"
	do
		local	dirPath="$EVAL_DIR/$arg"

		if ! [ -e "$dirPath" ]
		then
			echo "$dirPath does not exist"
		elif ! [ -d "$dirPath" ]
		then
			echo "$dirPath is not a directory"
		else
			echo "Opening $dirPath" && code "$dirPath"
		fi
	done
}

# Why do I not split this function into multiple segments?
#
# Well, I'm not sure if bash can have local function,
# and I don't want to pollute my namespace.
#
# Although this probably should be a script instead of a function.
function evalNew()
{
	local	EVAL_DIR="$EVAL"
	local	VOGSPHERE_PREFIX="git@vogsphere.42kl.edu.my:vogsphere/intra-uuid"

	if [ $# -ne 1 ]
	then
		echo "Usage: Eval <directory>" >&2 && return 1
	fi
	# I have no idea why path would overwrite PATH,
	# don't think it has anything to do with local either.
	local	dirPath="$EVAL_DIR/$1"

	if ! [ -e "$dirPath" ]
	then
		echo "$dirPath does not exist" >&2
		if getResponse "Create $dirPath?"
		then
			mkdir "$dirPath" && echo "Created $dirPath"
		else
			echo "Aborted" >&2 && return 1
		fi
	elif ! [ -d "$dirPath" ]
	then
		echo "$dirPath is not a directory" >&2 && return 1
	fi
	local	link

	if echo -n "vogsphere link: " >&2 && ! read link
	then
		echo Aborted >&2
	elif [ $(tr -cd '-' <<< "$link" | wc -c) -lt 8 ] \
		|| [[ "$link" != "$VOGSPHERE_PREFIX"* ]]
	then
		echo "Does not recognize as vogsphere repo: $link" >&2
	else
		dirPath+="/${link#*-*-*-*-*-*-*-*-}"
		git clone "$link" "$dirPath" && code "$dirPath"
		return
	fi
	return 1
}
