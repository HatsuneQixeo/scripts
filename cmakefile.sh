function cmakefile()
{
	echo "NAME		:=	$@"
	<< "EOF" cat

CC			:=	gcc
CXXFLAGS	:=	-Wall -Werror -Wextra
CXXFLAGS	+=	-g
# CXXFLAGS	+=	-Wno-unused-variable -Wno-unused-parameter -Wno-unused-function
ifdef SAN
CXXFLAGS	+=	-fsanitize=address -g -D SAN=1
endif

SRC_DIR		:=	srcs
SRCS		:=	$(shell find ${SRC_DIR} -name "*.c")

HEADER		:=	$(shell find ${SRC_DIR} -name "*.h")
HEADER		+=	libft/include/libft.h
CFLAGS		:=	$(addprefix -I, $(dir ${HEADER}))

OBJ_DIR		:=	objs
OBJS 		:=	$(patsubst ${SRC_DIR}%.c, ${OBJ_DIR}%.o, ${SRCS})

LIBFT		:=	libft/libft.a
LIBFT_MAKE	:=	make -C libft

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
	@printf "${LIGHT_CYAN}${CC} ${CXXFLAGS} ${LIBFT} \$${OBJS} -o $@${RESET}\n"
	@${CC} ${CXXFLAGS} ${LIBFT} $^ -o $@

clean:
	${LIBFT_MAKE} clean
	@printf "${RED}${RM} ${OBJ_DIR}${RESET}\n"
	@${RM} -r ${OBJ_DIR}

fclean: clean
	${LIBFT_MAKE} fclean
	@printf "${RED}${RM} ${NAME}${RESET}\n"
	@${RM} ${NAME}

re:	fclean all

thisre:
	${RM} -r ${NAME} ${OBJ_DIR}
	make all

norm:
	@norminette ${SRCS} ${HEADER}

normltr:
	@norminette ${SRCS} ${HEADER} | grep -v INVALID_HEADER

check:
	touch srcs/main.c
	make all
EOF
}

cmakefile $@ > Makefile
mkdir -p srcs
! [ -e srcs/main.c ] && > srcs/main.c
