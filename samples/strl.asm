;; This file is part of an assembler for bootnecklad's Titan
;; Copyright (C) 2011 Toby Thain, toby@telegraphics.com.au
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by  
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License  
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

; Titan assembly for strlen
; C:
; unsigned strl(char *str){
;     for(n = 0; *str++; ++n)
;         ;
;     return n;
; }  

; Code      Constants
; ----      ---------
; 31 bytes  6 bytes    = 37 total


#StrL
	LDM #One   ; (3)
	MOV A,B    ; (2)
	CLR A      ; (2)
#Loop
	LDM #Str   ; (3) <--- *  (note that we have to laboriously work out offsets by hand)
        XOR        ; (1) update flags
        XOR        ; (1) (I'm not sure if LDM update flags on Classic Titan)
	JPZ #Done  ; (3)
	ADD        ; (1)
	PSH A      ; (1)
	LDM 0x0009 ; (3) modify the low byte of instruction *'s address operand
	ADD        ; (1) for simplicity, ignore carry. Str must not cross 00 page boundary
	STM 0x0009 ; (3)
	POP A      ; (1)
	JMP #Loop  ; (3)
#Done
	; count is in A register
	JMP #Done  ; (3)
#One
	0x01
#Str
	0x4f
	0x48
	0x41
	0x49
	0x00

	
