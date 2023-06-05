# Not gonna have any significant impact in terms of memory gained,
# just a tool for cleaning the mess left behind

function makeFClean
{
	# Find all Makefiles and run fclean
	for dir in $(find . -name Makefile)
	do
		echo "Cleaning $(dirname "$dir")"
		(make -C $(dirname "$dir") fclean)
	done
}

function cleanRougePrograms()
{
	prg="$(find . -name a.out) $(find . -name '*.dSYM') $(find . -name '.DS_Store')"
	[[ "$prg" =~ ^[[:space:]]+$ ]] && return 1

	echo "Remove: ?"
	read -p "$prg [y/n] " -n 1
	echo

	if [[ "$REPLY" =~ ^[Yy]$ ]]
	then
		echo "Removing $prg"
		rm -r $prg
	fi
}

makeFClean
cleanRougePrograms
