function classtemplate_header ()
{
	local	name="$@"
	local	capguard="$(tr [:lower:] [:upper:] <<< "$name")_HPP"

	<< EOF cat
#ifndef $capguard
# define $capguard

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
	local	name="$@"

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
	dir="~$file"
	mkdir -p "$dir"
	classtemplate_header "$file" > "$dir/$file.hpp"
	classtemplate_source "$file" > "$dir/$file.cpp"
done
