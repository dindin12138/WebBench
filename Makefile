CFLAGS?=	-Wall -ggdb -W -O $(shell pkg-config --cflags libtirpc)
CC?=		gcc
LIBS?= $(shell pkg-config --libs libtirpc)
LDFLAGS?=
PREFIX?=	/usr/local/webbench
VERSION=1.5

all:   webbench tags

tags:  *.c
	-ctags *.c

install: webbench
	install -d $(DESTDIR)$(PREFIX)/bin
	install -s webbench $(DESTDIR)$(PREFIX)/bin
	ln -sf $(DESTDIR)$(PREFIX)/bin/webbench $(DESTDIR)/usr/local/bin/webbench

	install -d $(DESTDIR)/usr/local/man/man1
	install -d $(DESTDIR)$(PREFIX)/man/man1
	install -m 644 webbench.1 $(DESTDIR)$(PREFIX)/man/man1
	ln -sf $(DESTDIR)$(PREFIX)/man/man1/webbench.1 $(DESTDIR)/usr/local/man/man1/webbench.1

	install -d $(DESTDIR)$(PREFIX)/share/doc/webbench
	install -m 644 debian/copyright $(DESTDIR)$(PREFIX)/share/doc/webbench
	install -m 644 debian/changelog $(DESTDIR)$(PREFIX)/share/doc/webbench

webbench: webbench.o Makefile
	$(CC) $(CFLAGS) $(LDFLAGS) -o webbench webbench.o $(LIBS) 

clean:
	-rm -f *.o webbench *~ core *.core tags
	
tar:   clean
	# The original tar target was removed because it depended on TMPDIR
	# which was causing issues with the build.
	# A new tar target can be created here if needed.

webbench.o:	webbench.c socket.c Makefile

.PHONY: clean install all tar
