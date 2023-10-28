#!/bin/bash

function tclasstemplate_source()
{
	local	capguard="$(tr [:lower:] [:upper:] <<< "$name")_TPP"

	<< EOF cat
#ifndef $capguard
# define $capguard

# include "$name.hpp"

/* Constructors && Destructor */
$template
$templateName::$name(void)
{}

$template
$templateName::$name(const $name &ref)
{
	*this = ref;
}

$template
$templateName::~$name(void)
{}


/* Operator Overloads */
$template
$templateName	&$templateName::operator=(const $name &ref)
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

	<< EOF cat
#ifndef $capguard
# define $capguard

# include <iostream>

$template
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

# include "$name.tpp"

#endif
EOF
}

for name in "$@"
do
	template="template <typename T>"
	templateName="$name<T>"
	mkdir "$name" && (
		cd "$name" || exit 1
		tclasstemplate_header "$name" > "$name.hpp"
		tclasstemplate_source "$name" > "$name.tpp"
	) && echo "Created Template for Template class: $name"
done
