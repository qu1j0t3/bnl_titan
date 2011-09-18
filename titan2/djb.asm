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

; Titan-2 assembly for DJB hashing
; see e.g. http://devnotes.wikispaces.com/DJB+Hash+Function

#Djb
	LDC A, 0x15	; 5381 with hi byte in A
	LDC B, 0x05	; and lo in B
	CLR D
#Loop
	PSH D
	PSH A
	PSH B
	; five shifts:
	ADD A,A		; (1) do hi byte first because we don't care about its carry
	ADD B,B
	ADC A		; in case high bit was shifted out of A
	ADD A,A		; (2)
	ADD B,B
	ADC A
	ADD A,A		; (3)
	ADD B,B
	ADC A
	ADD A,A		; (4)
	ADD B,B
	ADC A
	ADD A,A		; (5)
	ADD B,B
	ADC A
	; now add in unshifted hash that we saved
	POP D		; saved hash lo
	POP C		; saved hash hi
	ADD B,D
	ADC A
	ADD A,C		; carry ignored
	; now add in next key byte
	POP D
	LDM C, #Key[D]
	ADD B,C
	ADC A
	; update index reg and check if all key bytes have been used
	LDC C, 0x01
	ADD D,C		; update index reg
	LDM C, #KeyLen
	SUB C, D
	JPZ #Done
	JMP #Loop
#Done
	JMP #Done

#KeyLen
	0x05
#Key
	0x55
	0x52
	0x4d
	0x4f
	0x4d
