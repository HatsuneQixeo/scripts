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

function tclasstemplate_source()
{
	local	capguard="$(capital_substitution "${name}")_TPP"

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

/* Log */
$template
std::ostream	&operator<<(std::ostream &os, const $templateName &ref)
{
	/* Log */
	return (os);
}


#endif
EOF
}

function tclasstemplate_header()
{
	local	capguard="$(capital_substitution "${name}")_HPP"

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

$template
std::ostream	&operator<<(std::ostream &os, const $templateName &ref);

# include "$name.tpp"

#endif
EOF
}

if [ $# -eq 0 ]
then
	echo "usage: $0 <class_name> ..."
	exit 1
fi

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
