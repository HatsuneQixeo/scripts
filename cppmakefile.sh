# Never Again
# function stdmain ()
# {
# 	<< "EOF" cat
# #include <iostream>

# int	main(void)
# {
# 	std::cout << "ミク: こんにちは、世界" << std::endl;
# }
# EOF
# }

function cppmakefile ()
{
	echo "NAME		:=	$@"
	<< "EOF" cat
CC			:=	c++
CPPFLAGS	:=	-Wall -Werror -Wextra -std=c++98
SRC_DIR		:=	srcs
HEADER		:=	$(shell find ${SRC_DIR} -name "*.hpp")
INCLUDE		:=	$(addprefix -I, $(dir ${HEADER}))
SRCS		:=	$(shell find ${SRC_DIR} -name "*.cpp")
OBJ_DIR		:=	objs
OBJS 		:=	$(patsubst ${SRC_DIR}%.cpp, ${OBJ_DIR}%.o, ${SRCS})
RM			:=	rm -rf

GREY		:=	\033[30m
RED			:=	\033[31m
CYAN		:=	\033[36m
LIGHT_CYAN	:=	\033[1;36m
RESET		:=	\033[0m

all: ${NAME}

${OBJ_DIR}:
	@printf "${GREY}mkdir $@${RESET}\n"
	@mkdir $@

${OBJ_DIR}/%.o: ${SRC_DIR}/%.cpp ${HEADER} | ${OBJ_DIR}
	@mkdir -p ${@D}
	@printf "${CYAN}${CC} ${CPPFLAGS} \$${INCLUDE} -c $< -o $@${RESET}\n"
	@${CC} ${CPPFLAGS} ${INCLUDE} -c $< -o $@

${NAME}: ${OBJS}
	@printf "${LIGHT_CYAN}${CC} ${CPPFLAGS} $^ -o $@${RESET}\n"
	@${CC} ${CPPFLAGS} $^ -o $@

san:
	@printf "${LIGHT_CYAN}SANITIZER: ON${RESET}\n"
	@${CC} ${CPPFLAGS} -fsanitize=address -g ${INCLUDE} ${SRCS} -o ${NAME}

clean:
	@printf "${RED}${RM} ${OBJ_DIR}${RESET}\n"
	@${RM} ${OBJ_DIR}

fclean: clean
	@printf "${RED}${RM} ${NAME}${RESET}\n"
	@${RM} ${NAME}

re:	fclean all

run: ${NAME}
	./$<

log: ${NAME}
	./$< > log.log
EOF
}

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
	"$ft_write" "${@:3}" > "$name"
}

if [ $# -eq 0 ]
then
	name='default'
else
	name="$@"
fi

ifexist cppmakefile Makefile "$name" 
# mkdir -p srcs
# ifexist stdmain "srcs/main.cpp"

