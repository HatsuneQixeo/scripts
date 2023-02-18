function stdmain ()
{
	<< "EOF" cat
#include <iostream>

int	main(void)
{
	std::cout << "ミク: こんにちは、世界" << std::endl;
}
EOF
}

function cppmakefile ()
{
	echo "NAME		:=	$1"
	<< "EOF" cat
CC			:=	c++
CPPFLAGS	:=	-Wall -Werror -Wextra -std=c++98 -I.
HEADER		:=	$(wildcard *.hpp)
SRC_DIR		:=	srcs/
SRCS		:=	$(wildcard ${SRC_DIR}*.cpp)
OBJ_DIR		:=	objs/
OBJS 		:=	$(patsubst ${SRC_DIR}%.cpp, ${OBJ_DIR}%.o, ${SRCS})
RM			:=	rm -rf

all: ${OBJ_DIR} ${NAME}

${OBJ_DIR}:
	mkdir $@

${OBJ_DIR}%.o: ${SRC_DIR}%.cpp ${HEADER}
	${CC} ${CPPFLAGS} -c $< -o $@

${NAME}: ${OBJS}
	${CC} ${CPPFLAGS} $^ -o $@

clean:
	${RM} ${OBJ_DIR}

fclean: clean
	${RM} ${NAME}

re:	fclean all
EOF
}

# function cmain ()
# {
# 	<< EOF cat
# #include <stdio.h>
# #include <stdlib.h>

# int	main(void)
# {
# 	printf("ミク: こんにちは、世界");
# }
# EOF
# }

# function cmakefile ()
# {
# 	echo "NAME		:=	$1"
# 	<< "EOF" cat
# CC			:=	gcc
# CFLAGS		:=	-Wall -Werror -Wextra -I.
# HEADER		:=	$(wildcard *.h)
# SRC_DIR		:=	srcs/
# SRCS		:=	$(wildcard ${SRC_DIR}*.c)
# OBJ_DIR		:=	objs/
# OBJS 		:=	$(patsubst ${SRC_DIR}%.c, ${OBJ_DIR}%.o, ${SRCS})
# RM			:=	rm -rf

# all: ${OBJ_DIR} ${NAME}

# ${OBJ_DIR}:
# 	mkdir $@

# ${OBJ_DIR}%.o: ${SRC_DIR}%.c ${HEADER}
# 	${CC} ${CFLAGS} -c $< -o $@

# ${NAME}: ${OBJS}
# 	${CC} ${CFLAGS} $^ -o $@

# clean:
# 	${RM} ${OBJ_DIR}

# fclean: clean
# 	${RM} ${NAME}

# re:	fclean all
# EOF
# }

# $1: function for writing
# $2: File writes into
# ${3-?}: Argument given to the function
function ifexist ()
{
	ft_write="$1"
	name="$2"
	if [ -e "$name" ]
	then
		read -p "($name) already exist. Overwrite [y/n]: " write
		if [ "$write" != 'y' ]
		then
			return 1
		fi
	fi
	"$ft_write" ${@:3} > "$name"
}

if [ $# -eq 0 ]
then
	name='default'
else
	name="$@"
	name="${name//" "/"_"}"
fi

ifexist cppmakefile Makefile "$name" 
mkdir -p srcs
ifexist stdmain "srcs/main.cpp"

