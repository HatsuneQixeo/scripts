#!/bin/bash

for dir in ex*/
do
	echo "exiter: $dir: ($@)"
	(cd "$dir" && $@)
	echo
done
