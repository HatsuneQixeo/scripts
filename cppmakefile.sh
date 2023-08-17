# Never Again
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
	echo "NAME		:=	$@"
	<< "EOF" cat

CXX			:=	c++
CXXFLAGS	:=	-Wall -Werror -Wextra -std=c++98 -pedantic
CXXFLAGS	+=	-g
# CXXFLAGS	+=	-Wno-unused-variable -Wno-unused-parameter -Wno-unused-function
ifdef SAN
CXXFLAGS	+=	-fsanitize=address -g -D SAN=1
endif

SRC_DIR		:=	srcs
SRCS		:=	$(shell find ${SRC_DIR} -name "*.cpp")
SRCS_T		:=	$(shell find ${SRC_DIR} -name "*.tpp")

HEADER		:=	$(shell find ${SRC_DIR} -name "*.hpp")
CPPFLAGS	:=	$(addprefix -I, $(dir ${HEADER}))

OBJ_DIR		:=	objs
OBJS 		:=	$(patsubst ${SRC_DIR}%.cpp, ${OBJ_DIR}%.o, ${SRCS})

GREY		:=	\033[30m
RED			:=	\033[31m
CYAN		:=	\033[36m
LIGHT_CYAN	:=	\033[1;36m
RESET		:=	\033[0m

all: ${NAME}

${OBJ_DIR}:
	@command="mkdir $@" && \
	printf "${GREY}$$command${RESET}\n"

${OBJ_DIR}/%.o: ${SRC_DIR}/%.cpp ${HEADER} ${SRCS_T} | ${OBJ_DIR}
	@mkdir -p ${@D}
	@command="${CXX} ${CXXFLAGS} ${CPPFLAGS} -c $< -o $@" \
	&& printf "${CYAN}$$(sed 's@${CFLAGS}@\$${CFLAGS}@g' <<< "$$command")${RESET}\n" \
	&& $$command

${NAME}: ${OBJS}
	@command="${CXX} ${CXXFLAGS} $^ -o $@" && \
	printf "${LIGHT_CYAN}$$command${RESET}\n" && \
	$$command

clean:
	@command="${RM} -r ${OBJ_DIR}" && \
	printf "${RED}$$command${RESET}\n" && \
	$$command

fclean: clean
	@command="${RM} ${NAME}" && \
	printf "${RED}$$command${RESET}\n" && \
	$$command

re:	fclean all
EOF
}

# $1: function for writing
# $2: File writes into
# ${3-?}: Argument given to the function
function ifexist ()
{
	local	ft_write="$1"
	local	name="$2"

	if [ -e "$name" ]
	then
		read -p "($name) already exist. Overwrite [y/n]: " write
		if [ "$write" != 'y' ]
		then
			return 1
		fi
	fi
	"$ft_write" "${@:3}" > "$name"
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
! [ -e srcs/main.cpp ] && stdmain > srcs/main.cpp
exit 1
