CFLAGS = -O2 -g
LDFLAGS = -g

bnlasm : assembler.o
	$(CC) -o $@ $^

clean : ; rm -f bnlasm assembler.o
