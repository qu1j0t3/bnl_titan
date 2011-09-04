; This file is part of an assembler for bootnecklad's Titan
; Copyright (C) 2011 Toby Thain, toby@telegraphics.com.au
;
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by  
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License  
; along with this program; if not, write to the Free Software
; Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

(include "titan.grm.scm")

  (define (make-lexer errorp)
    (let ((input '(NOP NEWLINE ADD NEWLINE PSH REG NEWLINE STM ACONST NEWLINE NEWLINE)))
      (lambda ()
        (if (null? input)
          '*eoi*
          (let ((next-token (car input)))
            (set! input (cdr input))
            next-token)))))

(define opcodes '((NOP . #x00)
                  (ADD . #x10)
                  (SUB . #x20)
                  (AND . #x30)
                  (OR  . #x40)
                  (NOT . #x50)
                  (XOR . #x60)
                  (PSH . #x70)
                  (POP . #x80)
                  (JMP . #x90)
                  (JPI . #xa0)
                  (JPZ . #xb0)
                  (JPC . #xc0)
                  (JPS . #xd0)
                  (STM . #xe0)
                  (LDM . #xf0)))
(define addr 0)

(define (assemble-byte v)
  (printf "~X ~X~n" addr (bitwise-and v #xff))
  (set! addr (+ addr 1)))
(define (assemble-word v)
  (assemble-byte (arithmetic-shift v -8))
  (assemble-byte v))
(define (assemble-op op param)
  (assemble-byte (+ (cdr (assv op opcodes)) param)))

(define (assemble-impl op)
  (assemble-op op 0)
  op)
(define (assemble-reg op reg)
  (assemble-op op 0)
  op)
(define (assemble-addr op addr)
  (assemble-op op 0)
  op)

(titan-parser (make-lexer print) print)

