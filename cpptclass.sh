#!/bin/bash

function tclasstemplate_source()
{
	local	capguard="$(tr [:lower:] [:upper:] <<< "$name")_TPP"
	local	templateName="$name<T>"

	<< EOF cat
#ifndef $capguard
# define $capguard

# include "$name.hpp"

/* Constructors && Destructor */
template <typename T>
$templateName::$constructor
{}

template <typename T>
$templateName::$name(const $templateName &ref)
{
	*this = ref;
}

template <typename T>
$templateName::~$name(void)
{}


/* Operator Overloads */
template <typename T>
$templateName	&$templateName::operator=(const $templateName &ref)
{
	if (this == &ref)
		return (*this);
	/* Copy assignment */
	return (*this);
}


/* Getters */



/* Member Functions */


#endif
EOF
}

function tclasstemplate_header()
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

	public:
		/* Constructors && Destructor */
		$constructor;
		$name(const $templateName &ref);
		~$name(void);

		/* Operator Overloads */
		$templateName	&operator=(const $templateName &ref);

		/* Getters */


		/* Member Functions */

};

# include "$name.tpp"

#endif
EOF
}

for name in "$@"
do
	mkdir -p "$name"
	constructor="$name(void)"
	tclasstemplate_header "$name" > "$name/$name.hpp"
	tclasstemplate_source "$name" > "$name/$name.tpp"
done
