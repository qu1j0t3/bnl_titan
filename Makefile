CFLAGS = -O2 -g
LDFLAGS = -g

bnlasm : assembler.o
	$(CC) $(LDFLAGS) -o $@ $^

clean : ; rm -f bnlasm assembler.o

%.grm.scm : %.grm ; csi -s $<

all : titan.grm.scm
