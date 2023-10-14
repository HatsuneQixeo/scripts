# killall basically, this is here for system without it

if [ $# -eq 0 ]
then
	echo "This script kill every processes found with given arguments as the process name"
	exit 1
fi

for name in "$@"
do
	process=$(ps | grep -v grep | grep -v kill.sh | grep "$name")

	if [ -z "$process" ]
	then
		echo "No existing process: $name"
		continue
	fi
	# echo PROCESS: $process

	pid=$(echo "$process" | awk '{print $1}')
	# echo PID: $pid

	if kill $pid
	then
		echo "Killed $(echo $pid | wc -w | cat) $name processes"
	else
		echo 'Something went wrong with kill'
	fi
done
