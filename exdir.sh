prgname="exdir"

function exdir_echo ()
{
	echo "$prgname: $@"
}

function exdir_error ()
{
	echo "$prgname: error: $@"
	exit 1
}

function exmake ()
{
	amount="$1"

	if [ -z "$amount" ]
	then
		exdir_error "Missing argument for make"
	elif ! [[ "$amount" =~ ^-?[0-9]+$ ]]
	then
		exdir_error "$amount is not integer"
	elif [ $amount -gt 100 ]
	then
		exdir_error "$amount is more than 100"
	fi

	echo "$prgname: make: ex00 - ex$(printf "%02d" $(($amount - 1)))" 
	for (( i = 0; i < $amount; i++))
	do
		dirname=""ex$(printf "%02d" $i)""
		if ! [ -e "$dirname" ]
		then
			mkdir $dirname && exdir_echo "Maked: $dirname"
		fi
	done
}

function exclean ()
{
	exdir_echo "clean: ex00 - ex99"
	for i in {0..99}
	do
		dirname="ex$(printf "%02d" $i)"
		if [ -e "$dirname" ]
		then
			rmdir $dirname && exdir_echo "Removed: $dirname"
		fi
	done
}

function exfclean ()
{
	read -p "$prgname: Force clean will wipe everything, are you sure? [y/n] " write
	if [ "$write" != 'y' ]
	then
		exdir_echo "Canceled fclean"
		return 1
	fi

	exdir_echo "fclean: ex00 - ex99"
	for i in {0..99}
	do
		dirname="ex$(printf "%02d" $i)"
		if [ -e "$dirname" ]
		then
			rm -rf "$dirname" && exdir_echo "Removed: $dirname"
		fi
	done
}

if [ $# -eq 0 ]
then
	<< "EOF" cat
exdir.sh <action> <amount>
	action
		* make	: create ex00 to ex$((amount - 1))
		* clean	: remove ex00 to ex99
		* fclean: force remove ex00 to ex99
	amount: amount to make, maximum 100
EOF
	exit 0
elif [ $# -gt 2 ]
then
	exdir_error "Too many arguments"
fi

action="$1"

if [ "$action" == "clean" ]
then
	exclean
elif [ "$action" == "fclean" ]
then
	exfclean
elif [ "$action" == "make" ]
then
	exmake "$2"
else
	exdir_error "Unknown action: $action"
fi
