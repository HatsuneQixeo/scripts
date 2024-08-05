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
	local	capguard="$(capital_substitution "${name}")_HPP"

	<< EOF cat
#ifndef $capguard
# define $capguard

# include <iosfwd>

class $name
{
	private:

	public:
		/* Constructors && Destructor */
		$name(void);
		$name(const $name &ref);
		~$name(void);

		/* Operator Overloads */
		$name	&operator=(const $name &ref);

		/* Getters */


		/* Member Functions */

};

std::ostream	&operator<<(std::ostream &os, const $name &ref);

#endif
EOF
}

function classtemplate_source()
{
	<< EOF cat
#include "$name.hpp"

#include <iostream>

/* Constructors && Destructor */
$name::$name(void)
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

/* Log */
std::ostream	&operator<<(std::ostream &os, const $name &ref)
{
	/* Log */
	return (os);
}
EOF
}

if [ $# -eq 0 ]
then
	echo "usage: $0 <class_name> ..."
	exit 1
fi

for name in "$@"
do
	mkdir "$name" && (
		cd "$name" || exit 1
		classtemplate_header "$name" > "$name.hpp"
		classtemplate_source "$name" > "$name.cpp"
	) && echo "Created Template for class: $name"
done
