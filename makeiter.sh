
lst_dir="$(ls -d */)"

for dir in $lst_dir
do
	echo "make -C $dir $1"
	make -C "$dir" $1
done
