#!/bin/bash

function classtemplate_header ()
{
	local	capguard="$(tr [:lower:] [:upper:] <<< "$name")_HPP"
	local	templateName="$name<T>"

	<< EOF cat
#ifndef $capguard
# define $capguard

# include <iostream>

template <typename T>
class $name
{
	private:
		T	data;

	public:
		/* Constructor && Destructor */
		$constructor;
		$name(const $templateName &ref);
		~$name(void);

		/* OperatorOverload */
		$name	&operator=(const $templateName &ref);

		/* Getters */


		/* MemberFunctions */

};

/* Constructor && Destructor */
$templateName::$constructor
{}

$templateName::$name(const $templateName &ref)
{
	*this = ref;
}

$templateName::~$name(void)
{}


/* Operator Overload */
$name	&$templateName::operator=(const $templateName &ref)
{
	/* Copy assignment */
	return (*this);
}


/* Getters */



/* MemberFunctions */


#endif
EOF
}

for name in "$@"
do
	mkdir -p "$name"
	constructor="$name(void)"
	classtemplate_header "$name" > "$name/$name.hpp"
	classtemplate_source "$name" > "$name/$name.cpp"
done
