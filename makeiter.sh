for dir in ex*/
do
	echo "make -C $dir $1"
	make -C "$dir" $1
done
