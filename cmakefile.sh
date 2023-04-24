function cmakefile()
{
	echo NAME		:=	$@
	<< "EOF" cat
CC			:=	gcc
CXXFLAGS	:=	-Wall -Werror -Wextra

SRC_DIR		:=	srcs
SRCS		:=	$(shell find ${SRC_DIR} -name "*.c")

HEADER		:=	$(shell find ${SRC_DIR} -name "*.h") libft/include/libft.h
CFLAGS		:=	$(addprefix -I, $(dir ${HEADER}))

OBJ_DIR		:=	objs
OBJS 		:=	$(patsubst ${SRC_DIR}%.c, ${OBJ_DIR}%.o, ${SRCS})

LIBFT		:=	libft/libft.a
LIBFT_MAKE	:=	make -C libft

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

${OBJ_DIR}/%.o: ${SRC_DIR}/%.c ${HEADER} | ${OBJ_DIR}
	@mkdir -p ${@D}
	@printf "${CYAN}${CC} ${CXXFLAGS} \$${CFLAGS} -c $< -o $@${RESET}\n"
	@${CC} ${CXXFLAGS} ${CFLAGS} -c $< -o $@

${NAME}: ${OBJS}
	${LIBFT_MAKE}
	@printf "${LIGHT_CYAN}${CC} ${CXXFLAGS} $^ -o $@${RESET}\n"
	@${CC} ${CXXFLAGS} ${LIBFT} $^ -o $@

san:
	@printf "${LIGHT_CYAN}SANITIZER: ON${RESET}\n"
	@${CC} ${CXXFLAGS} -fsanitize=address -g ${LIBFT} ${CFLAGS} ${SRCS} -o ${NAME}

clean:
	${LIBFT_MAKE} clean
	@printf "${RED}${RM} ${OBJ_DIR}${RESET}\n"
	@${RM} ${OBJ_DIR}

fclean: clean
	${LIBFT_MAKE} fclean
	@printf "${RED}${RM} ${NAME}${RESET}\n"
	@${RM} ${NAME}

re:	fclean all

run: ${NAME}
	./$<

log: ${NAME}
	./$< > log.log
EOF
}


cmakefile $@ > Makefile
mkdir -p srcs
! [ -e srcs/main.c ] && > srcs/main.c
