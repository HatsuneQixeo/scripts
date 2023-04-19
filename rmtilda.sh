for arg in \~*
do
	mv "$arg" "${arg/#~/}"
done
