function classtemplate_header ()
{
	name="$@"
	capname="$(tr [:lower:] [:upper:] <<< "$name")"
	<< EOF cat
#ifndef ${capname}_HPP
# define ${capname}_HPP

# include <iostream>

class $name
{
	private:

	public:
		$name(void);
		$name(const $name &ref);
		~$name(void);
		$name	&operator=(const $name &ref);
};

#endif
EOF
}

function classtemplate_source ()
{
	name="$@"
	<< EOF cat
#include "$name.hpp"

$name::$name(void)
{
	std::cout << "$name Default Constructor" << std::endl;
}

$name::$name(const $name &ref)
{
	std::cout << "$name Copy Constructor" << std::endl;
	*this = ref;
}

$name	&$name::operator=(const $name &ref)
{
	std::cout << "$name Copy Assignment Operator" << std::endl;
	/* Copy assignment */
	return (*this);
}

$name::~$name(void)
{
	std::cout << "$name Destructor" << std::endl;
}
EOF
}

for file in "$@"
do
	file="${file// /_}"
	classtemplate_header "$file" > "$file.hpp"
	classtemplate_source "$file" > "$file.cpp"
done
