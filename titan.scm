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
    (let ((input '(NOP NEWLINE
                   ADD NEWLINE
                   PSH (REG #\B) NEWLINE
                   POP (REG #\X) NEWLINE
                   STM (ACONST 1234)
                   NEWLINE
                   NEWLINE)))
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

(define (hex-nibble v)
  (let ((masked (bitwise-and v #xf)))
    (integer->char
      (if (< masked 10)
        (+ masked (char->integer #\0))
        (+ (- masked 10) (char->integer #\A))))))
(define (hex-byte v)
  (list->string (map hex-nibble (list (arithmetic-shift v -4) v))))
(define (hex-word v)
  (apply string-append (map hex-byte (list (arithmetic-shift v -8) v))))

(define (assemble-byte v)
  (print (hex-word addr) "  " (hex-byte v))
  (set! addr (+ addr 1)))
(define (assemble-word v)
  (assemble-byte (arithmetic-shift v -8))
  (assemble-byte v))
(define (assemble-op op param)
  (assemble-byte (+ (cdr (assv op opcodes)) param)))

; the following are called from the grammar
(define (list-line lst)
  (display "      ")
  (for-each (lambda (x) (display x) (display #\space))
            lst)
  (display #\newline))
(define (assemble-impl op)
  (assemble-op op 0)
  (list op))
(define (assemble-reg op reg)
  (let ((reg-number (- (char->integer (char-upcase (car reg)))
                       (char->integer #\A))))
    (if (and (>= reg-number 0) (<= reg-number 15))
      (begin
        (assemble-op op reg-number)
        (list op (car reg)))
      (begin
        (list 'bad-register (car reg))))))
(define (assemble-addr op addr)
  (let ((address (car addr)))
    (if (and (>= address 0) (<= address #xffff))
      (begin
        (assemble-op op 0)
        (assemble-word address)
        (list op (string-append "0x" (hex-word address))))
      (begin
        (list 'bad-address address)))))

(titan-parser (make-lexer print) print)

