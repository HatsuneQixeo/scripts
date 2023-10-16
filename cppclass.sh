#!/bin/bash

function capital_substitution()
{
	local	str="$1"
	local	result
	local	prev_islower=1

	for ((i = 0; i < ${#str}; i++))
	do
		local	c="${str:$i:1}"

		[ $prev_islower -eq 0 ] && [[ "$c" =~ [[:upper:]] ]] && result+="_"
		[[ "$c" =~ [[:lower:]] ]]; prev_islower=$?
		result+="$c"
	done
	echo "$result" | tr [:lower:] [:upper:]
}

function classtemplate_header()
{
	local	capguard="$(capital_substitution "${name}HPP")"

	<< EOF cat
#ifndef $capguard
# define $capguard

# include <iostream>

class $name
{
	private:

	public:
		/* Constructors && Destructor */
		$constructor;
		$name(const $name &ref);
		~$name(void);

		/* Operator Overloads */
		$name	&operator=(const $name &ref);

		/* Getters */


		/* Member Functions */

};

#endif
EOF
}

function classtemplate_source()
{
	<< EOF cat
#include "$name.hpp"

/* Constructors && Destructor */
$name::$constructor
{}

$name::$name(const $name &ref)
{
	*this = ref;
}

$name::~$name(void)
{}


/* Operator Overloads */
$name	&$name::operator=(const $name &ref)
{
	if (this == &ref)
		return (*this);
	/* Copy assignment */
	return (*this);
}


/* Getters */



/* Member Functions */


EOF
}

for name in "$@"
do
	mkdir -p "$name"
	constructor="$name(void)"
	classtemplate_header "$name" > "$name/$name.hpp"
	classtemplate_source "$name" > "$name/$name.cpp"
done
