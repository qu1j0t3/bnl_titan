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

; Titan-2 assembly for strlen
; C:
;   unsigned strl(char *str){
;       for(n = 0; *str++; ++n)
;           ;
;       return n;
;   }  

; Code      Constants
; ----      ---------
; 17 bytes  5 bytes    = 22 total

#StrL
	LDC B, 0x01    ; (2)
	CLR D          ; (1) XOR D,D
#Loop
	LDM C, #Str[D] ; (3)
	TST C          ; (1) update flags = AND C,C
	JPZ #Done      ; (3)
	ADD D, B       ; (1) for simplicity, ignore carry. Str must not cross 00 page boundary
	JMP #Loop      ; (3)
#Done
	; count is in C register
	JMP #Done      ; (3)
#Str
	0x4f
	0x48
	0x41
	0x49
	0x00

	
