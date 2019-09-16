PROG=	feedrandom
SRCS=	feedrandom.c sha512.c sha512-api.c writeentropy.c
OBJS=	feedrandom.o sha512.o sha512-api.o writeentropy.o

CC=		cc
CFLAGS+= -O2 -pipe -std=gnu99 -pedantic -Wall
LIBS+= -lbsd

all: $(PROG)

$(PROG): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^ $(LIBS)

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f $(PROG) $(OBJS)
