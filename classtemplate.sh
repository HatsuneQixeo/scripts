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
		$constructor;
		$name(const $name &ref);
		~$name(void);
		$name	&operator=(const $name &ref);
};

#endif
EOF
}

function classtemplate_source ()
{
	<< EOF cat
#include "$name.hpp"

$name::$constructor
{
}

$name::$name(const $name &ref)
{
	*this = ref;
}

$name	&$name::operator=(const $name &ref)
{
	/* Copy assignment */
	return (*this);
}

$name::~$name(void)
{
}
EOF
}

for name in "$@"
do
	dir="~$name"
	mkdir -p "$dir"
	constructor="$name(void)"
	classtemplate_header "$name" > "$dir/$name.hpp"
	classtemplate_source "$name" > "$dir/$name.cpp"
done
