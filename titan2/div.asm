; Integer division
; Copyright (C) 2011 Toby Thain <toby@telegraphics.com.au>

;void d(unsigned a, unsigned b, unsigned *q, unsigned *r){
;	unsigned c, e, t;
;	*q = 0;
;	while(a >= b){
;		// b divides into a at least once.
;		// find the largest binary multiple of b that divides into a.
;		// use e to track the multiplier of b.
;		c = b;
;		e = 1; // start with 1 x b
;		t = c+c; // FIXME: careful of overflow
;		while(t <= a){ // would the NEXT multiple divide a?
;			e += e;
;			c = t;
;			t += t;
;		}
;		a -= c; // subtract the trial multiple of b
;		*q += e; // add multiplier to the quotient
;	}
;	*r = a;
;}

; Entry: A is dividend
;        B is divisor
; Exit:  H is quotient
;        A is remainder


#Div
	CLR H		; quotient
	MOV A, G
	SUB G, B
	JPS #Done	; when divisor is greater than remainder of dividend, we're finished
#Trial
	  MOV B, C	; trial divisor starts at original divisor
	  LDC E, #1	; multiple in trial
	  MOV C, F
	  ADD F, C	; compute next trial divisor
#Shift
	    MOV A, G
	    SUB G, F
	    JPS #DoneShift	; stop shifting if next trial won't divide
	    ADD E, E	; double multiplier
	    ADD F, F	; and double trial divisor
	    JMP #Shift
#DoneShift
	  SUB A, C	; subtract trial multiple of divisor
	  ADD H, E	; add multiplier to quotient
	  JMP #Trial	; continue
#Done
	JMP #Done


	
