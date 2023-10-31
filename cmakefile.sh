function cmakefile()
{
	echo "NAME		:=	$@"
	<< "EOF" cat

CC			:=	gcc
CC			+=	-fsanitize=address -g -D SAN=1

CXXFLAGS	:=	-Wall -Wextra -Werror -pedantic -MMD
CXXFLAGS	+=	-g
# CXXFLAGS	+=	-Wno-unused-variable -Wno-unused-parameter -Wno-unused-function
ifdef SAN
endif

SRC_DIR		:=	srcs
SRCS		:=	$(shell find ${SRC_DIR} -name "*.c")

HEADER		:=	$(shell find ${SRC_DIR} -name "*.h")
CFLAGS		:=	$(addprefix -I, $(dir ${HEADER}) libft/include)

OBJ_DIR		:=	objs
OBJS 		:=	$(patsubst ${SRC_DIR}%.c, ${OBJ_DIR}%.o, ${SRCS})

DEPENDS		:=	$(patsubst %.o, %.d, ${OBJS})

LIBFT		:=	libft/libft.a
LIBFT_MAKE	:=	make -C libft

GREY		:=	\033[30m
RED			:=	\033[31m
CYAN		:=	\033[36m
LIGHT_CYAN	:=	\033[1;36m
RESET		:=	\033[0m

all: libftupdate ${NAME}

-include ${DEPENDS}

libftupdate:
	${LIBFT_MAKE}

${OBJ_DIR}/%.o: ${SRC_DIR}/%.c
	@mkdir -p ${@D}
	@command="${CC} ${CXXFLAGS} ${CFLAGS} -c $< -o $@" \
	&& printf "${CYAN}$$(sed 's@${CFLAGS}@\$${CFLAGS}@g' <<< "$$command")${RESET}\n" \
	&& $$command

${NAME}: ${OBJS} ${LIBFT}
	@command="${CC} $^ -o $@" \
	&& printf "${LIGHT_CYAN}$$(sed 's@${OBJS}@\$${OBJS}@g' <<< "$$command")${RESET}\n" \
	&& $$command

clean:
	${LIBFT_MAKE} clean
	@command="${RM} -r ${OBJ_DIR}" \
	&& printf "${RED}$$command${RESET}\n" \
	&& $$command

fclean: clean
	${LIBFT_MAKE} fclean
	@command="${RM} ${NAME}" \
	&& printf "${RED}$$command${RESET}\n" \
	&& $$command

re:	fclean all

thisre:
	@command="${RM} -r ${NAME} ${OBJ_DIR}" \
	&& printf "${RED}$$command${RESET}\n" \
	&& $$command
	make all

norm:
	@norminette ${SRCS} ${HEADER}

normltr:
	@norminette ${SRCS} ${HEADER} | grep -v INVALID_HEADER

header:
	42header.sh ${SRCS} ${HEADER}

check:
	touch srcs/main.c
	make all
EOF
}

cmakefile $@ > Makefile
mkdir -p srcs
! [ -e srcs/main.c ] && > srcs/main.c
exit 0
