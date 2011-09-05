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

(define opcodes '((NOP . #x00) (ADD . #x10) (SUB . #x20) (AND . #x30)
                  (OR  . #x40) (NOT . #x50) (XOR . #x60) (PSH . #x70)
                  (POP . #x80) (JMP . #x90) (JPI . #xa0) (JPZ . #xb0)
                  (JPC . #xc0) (JPS . #xd0) (STM . #xe0) (LDM . #xf0)
                  ; pseudo-instructions
                  (MOV . #f)))

; ------ lexical analyser. produces stream of tokens for parser ------

(define (make-lexer errorp)

  ; read a sequence of letters into a list
  ; ends at a non-alphabetic, or EOF
  (define (read-alpha)
    (if (char-alphabetic? (peek-char))
      (cons (char-upcase (read-char)) (read-alpha))
      '()))

  ; read a literal constant: a series of hex digits preceded by '0x'
  (define (read-addr)
    (define (read-hex)
      (let loop ((acc 0)
                 (c (peek-char)))
        (if (whitespace-or-eof? c)
          acc
          (loop (+ (arithmetic-shift acc 4)
                   (hex-digit (read-char)))
                (peek-char)))))
    (read-char) ; skip 0
    (if (char=? (char-upcase (read-char)) #\X)
      (let ((addr (read-hex)))
        (if (and (>= addr 0) (<= addr #xffff))
          (list 'ACONST addr)
          'bad-address))
      'expected-0x))

  ; eat characters up to newline (or EOF)
  (define (skip-comment)    
    (let ((c (read-char)))  ; eat one
      (if (or (eof-object? c)
              (char=? c #\newline))
        'NEWLINE            ; a comment (including terminating newline) is a NEWLINE token
        (skip-comment))))

  (define (word-token lst)
    ;(print "word-token: " lst)
    (if (null? (cdr lst))
      (let ((reg-number (char->reg (car lst))))
        (if (and (>= reg-number 0) (<= reg-number 15))
          (list 'REG reg-number)
          (list 'bad-register (car lst))))
      (let* ((sym (string->symbol (list->string lst)))
             (lkp (assv sym opcodes)))
        (if (pair? lkp)
          (car lkp)
          (list 'bad-opcode sym)))))
        
  (lambda ()
    (let loop ((c (peek-char)))
      (cond
        ((eof-object? c)
          '*eoi*)
        ((char=? c #\newline)
          (read-char)         ; eat it
          'NEWLINE)
        ((char=? c #\,)
          (read-char)         ; eat it
          'COMMA)
        ((char-whitespace? c) ; skip whitespace
          (read-char)
          (loop (peek-char)))
        ((char=? c #\/)       ; introduces comment
          (skip-comment))
        ((char-alphabetic? c) ; read a 'word'
          (word-token (read-alpha)))
        ((char=? c #\0)       ; introduces an address constant
          (read-addr))
        (else
          (list 'bad-character c))))))
    
; ------ utility routines ------

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

(define (hex-digit chr)
  (let ((c (char-upcase chr)))
    (cond
      ((char-numeric? c)
        (- (char->integer c) (char->integer #\0)))
      ((and (char>=? c #\A) (char<=? c #\F))
        (+ 10 (- (char->integer c) (char->integer #\A))))
      (else
        (list 'bad-hex c)))))

(define (assemble-byte v)
  (print (hex-word addr) "  " (hex-byte v))
  (set! addr (+ addr 1)))
(define (assemble-word v)
  (assemble-byte (arithmetic-shift v -8))
  (assemble-byte v))
(define (assemble-op op param)
  (assemble-byte (+ (cdr (assv op opcodes)) param)))

(define (char->reg c)
  (- (char->integer (char-upcase c))
     (char->integer #\A)))
(define (reg->char r)
  (integer->char (+ (char->integer #\A) r)))

(define (whitespace-or-eof? c)
  (or (eof-object? c)
      (char-whitespace? c)))

; ------ these routines are called from the grammar ------

; assembly base address
(define addr 0)

(define (list-line lst)
  (display "      ")
  (for-each (lambda (x) (display x) (display #\space))
            lst)
  (display #\newline))

; assemble an instruction with 'implicit' addressing mode (no operands)
(define (assemble-impl op)
  (assemble-op op 0)
  (list op))

; assemble a register instruction; operand is register number
(define (assemble-reg op reg-number)
  (assemble-op op reg-number)
  (list op (reg->char reg-number)))

; assemble a memory instruction; operand is a 16 bit address
(define (assemble-addr op addr)
  (assemble-op op 0)
  (assemble-word addr)
  (list op (string-append "0x" (hex-word addr))))

(define (errorp . args)
  (apply print args)
  (exit 1))

; ------ start the parser ------

(titan-parser (make-lexer errorp) errorp)

