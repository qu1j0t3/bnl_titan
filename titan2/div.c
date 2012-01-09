/* Integer division */
/* Copyright (C) 2011 Toby Thain <toby@telegraphics.com.au> */

#include <stdio.h>
#include <stdlib.h>


void d(unsigned a, unsigned b, unsigned *q, unsigned *r){
	unsigned c, e, t;
	*q = 0;
	while(a >= b){
		// b divides into a at least once.
		// find the largest binary multiple of b that divides into a.
		// use e to track the multiplier of b.
		c = b;
		e = 1; // start with 1 x b
		t = c+c; // FIXME: careful of overflow
		while(t <= a){ // would the NEXT multiple divide a?
			e += e;
			c = t;
			t += t;
		}
		a -= c; // subtract the trial multiple of b
		*q += e; // add multiplier to the quotient
	}
	*r = a;
}

int main(int argc, char *argv[]){
	if(argc == 3){
		unsigned a = atoi(argv[1]), b = atoi(argv[2]), q, r;
		if(b != 0){
			d(a, b, &q, &r);
			printf("%u / %u = %u with remainder %u\n", a, b, q, r);
			return EXIT_SUCCESS;
		}
	}
	return EXIT_FAILURE;
}

