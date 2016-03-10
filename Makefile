INCDIR ?= -I /usr/local/include
CXXFLAGS = -Wno-everything -O3 -g0 ${INCDIR}
LDFLAGS = $(CXXFLAGS)

# OpenBSD and Bitrig require egcc and eg++
# System compiler on OpenBSD is too old and clang on gcc
# produces broken exectuable.
CC ?= egcc
CXX ?= eg++

dnsseed: dns.o bitcoin.o netbase.o protocol.o db.o main.o util.o blake256.o
	${CXX} -pthread $(LDFLAGS) -o dnsseed dns.o bitcoin.o netbase.o protocol.o db.o main.o util.o blake256.o -lcrypto

%.o: %.cpp bitcoin.h netbase.h protocol.h db.h serialize.h uint256.h util.h blake.h blake256.h
	${CXX} -pthread $(CXXFLAGS) -Wno-invalid-offsetof -c -o $@ $<

%.o: %.c blake.h
	${CC} $(CXXFLAGS) -c -o $@ $<

dns.o: dns.c
	${CC} -pthread -std=c99 $(CXXFLAGS) dns.c -c -o dns.o

%.o: %.cpp

clean:
	rm -f dnsseed
	rm -f *.o
