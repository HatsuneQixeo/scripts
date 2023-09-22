#!/bin/bash

function classtemplate_header ()
{
	local	capguard="$(tr [:lower:] [:upper:] <<< "$name")_HPP"

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

function classtemplate_source ()
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
