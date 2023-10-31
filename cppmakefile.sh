# Never Again
function stdmain ()
{
	<< "EOF" cat
#include "stdafx.hpp"

int	main(void)
{
	std::cout << "ミク: こんにちは、世界" << std::endl;
}
EOF
}

function cppmakefile ()
{
	echo "NAME		:=	$@"
	<< "EOF" cat

CXX			:=	c++
# CXX			+=	-fsanitize=address -g -D SAN=1

CXXFLAGS	:=	-Wall -Wextra -Werror -std=c++98
CXXFLAGS	+=	-g
# CXXFLAGS	+=	-pedantic
# CXXFLAGS	+=	-Wno-unused -Wno-unused-parameter

SRC_DIR		:=	srcs
SRCS		:=	$(shell find ${SRC_DIR} -name "*.cpp")

OBJ_DIR		:=	objs
OBJS		:=	$(patsubst ${SRC_DIR}%.cpp, ${OBJ_DIR}%.o, ${SRCS})

STDAFX		:=	${SRC_DIR}/stdafx.hpp
PCH			:=	${patsubst ${SRC_DIR}/%.hpp, ${OBJ_DIR}/%.gch, ${STDAFX}}

HEADER		:=	$(shell find ${SRC_DIR} -name "*.hpp")
CPPFLAGS	:=	$(addprefix -I, $(dir ${HEADER}))
CPPFLAGS	+=	-include-pch ${PCH}
CPPFLAGS	+=	-MMD

GREY		:=	\033[30m
RED			:=	\033[31m
CYAN		:=	\033[36m
LIGHT_CYAN	:=	\033[1;36m
RESET		:=	\033[0m

all: ${NAME}

-include $(patsubst %.o, %.d, ${OBJS} ${MAIN_OBJS})

${OBJ_DIR}:
	mkdir $@

${PCH}: ${STDAFX} | ${OBJ_DIR}
	${CXX} ${CXXFLAGS} $< -o $@

${OBJ_DIR}/%.o: ${SRC_DIR}/%.cpp | ${PCH}
	@mkdir -p ${@D}
	@command="${CXX} ${CXXFLAGS} ${CPPFLAGS} -c $< -o $@" \
	&& printf "${CYAN}$$(sed 's@${CPPFLAGS}@\$${CPPFLAGS}@g' <<< "$$command")${RESET}\n" \
	&& $$command

${NAME}: ${OBJS}
	@command="${CXX} $^ -o $@" \
	&& printf "${LIGHT_CYAN}$$(sed 's@$^@\$${OBJS}@g' <<< "$$command")${RESET}\n" \
	&& $$command

clean:
	@command="${RM} -r ${OBJ_DIR}" \
	&& printf "${RED}$$command${RESET}\n" \
	&& $$command

fclean: clean
	@command="${RM} ${NAME}" \
	&& printf "${RED}$$command${RESET}\n" \
	&& $$command

re:	fclean all
EOF
}

function stdafx()
{
	<< "EOF" cat
#ifndef STDAFX_HPP
# define STDAFX_HPP

/* I/O */
# include <iostream>
# include <fstream>
# include <sstream>
# include <iomanip>

/* Container */
# include <array>
# include <vector>
# include <map>
# include <list>

#endif
EOF
}

# $1: function for writing
# $2: File writes into
# ${3-?}: Argument given to the function
function ifexist ()
{
	local	ft_write="$1"
	local	filename="$2"
	local	args="${@:3}"
	local	action="Created"

	if [ -e "$filename" ]
	then
		read -p "($filename) already exist. Overwrite [y/n]: " write
		if ! [[ "$write" =~ ^['yY']$ ]]
		then
			echo "Aborted" >&2
			return 1
		fi
		action="Overwrote"
	fi
	"$ft_write" "$args" > "$filename"
	echo "$action $filename"
}

if [ $# -eq 0 ]
then
	name='default'
else
	name="$@"
fi

ifexist cppmakefile Makefile "$name"
mkdir -p srcs
# ifexist stdmain "srcs/main.cpp"
! [ -e srcs/stdafx.hpp ] && stdafx > srcs/stdafx.hpp
! [ -e srcs/main.cpp ] && stdmain > srcs/main.cpp
exit 0
