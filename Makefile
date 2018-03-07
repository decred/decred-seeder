INCDIR ?= -I /usr/local/include
STATIC ?=
CXXFLAGS = $(STATIC) -Wno-everything -O3 -g0 ${INCDIR}
LDFLAGS = $(CXXFLAGS)

# OpenBSD and Bitrig require egcc and eg++
# System compiler on OpenBSD is too old and clang on gcc
# produces broken exectuable.
CC ?= cc
CXX ?= c++

dnsseed: dns.o bitcoin.o netbase.o protocol.o db.o main.o util.o blake256.o
	${CXX} -pthread $(LDFLAGS) -o dnsseed dns.o bitcoin.o netbase.o protocol.o db.o main.o util.o blake256.o -lcrypto

%.o: %.cpp bitcoin.h netbase.h protocol.h db.h serialize.h uint256.h util.h
	${CXX} -std=c++11 -pthread $(CXXFLAGS) -Wall -Wno-unused -Wno-sign-compare -Wno-reorder -Wno-comment -c -o $@ $<

%.o: %.c blake.h blake256.h
	${CC} $(CXXFLAGS) -c -o $@ $<

dns.o: dns.c
	${CC} -pthread -std=c99 $(CXXFLAGS) dns.c -Wall -c -o dns.o

%.o: %.cpp

clean:
	rm -f dnsseed
	rm -f *.o
