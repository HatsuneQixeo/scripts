function getamount ()
{
	if [ -z "$1" ]; then
		return 0
	elif
}

function exmake ()
{
	amount="$1"

	if [ -z "$amount" ]; then
		return 1
	fi
	echo "$0: making ex00 - ex$(($amount - 1))"
	for (( i = 0; i < $amount; i++))
	do
		mkdir ex$i
	done
}

function exclean ()
{
	if [ -z "$1" ]; then
		amount=99
	else
		amount=$1
	fi
	echo "$0: cleaning"
	for i in {0..99}
	do
		rmdir ex$i
	done
}

function exfclean ()
{
	read -p "$0: Force clean will wipe everything, are you sure? [y/n]" write
	if [ "$write" != 'y' ]; then
		echo "$0: Canceled fclean"
		return 1
	fi
	echo "$0: fclean: ex00 - ex$2"
	for i in {0..99}
	do
		rm -rf ex$i
	done
}

action="$1"

if [ "$action" == "clean" ]; then
	exclean
elif ! [[ "$2" =~ ^-?[0-9]+$ ]]; then
	echo "error: $2 is not an integer"
	exit 1
elif [ "$action" == "make" ]; then
	exmake "$2"
else
	echo "unknown action: $action"
	exit 1
fi

amount="$2"
