
lst_dir="$(ls -d */)"

echo "$lst_dir"
for dir in $lst_dir
do
	echo "make -C $dir $1"
	make -C "$dir" "$1"
done
