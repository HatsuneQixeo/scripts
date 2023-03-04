function header ()
{
	local	name="$1"
	local	capguard="$(tr [:lower:] [:upper:] <<< "$name")_H"
	<< EOF cat
#ifndef $capguard
# define $capguard

# include "libft.h"

#endif
EOF
}

if [ $# -eq 0 ]
then
	exit
fi

name="$*"
name=${name// /_}
header "$name" > "$name".h
