#lang planet neil/sicp

;define variable
(define pi 3.14159)

;define function
(define (square x) (* x x))

(define (abs x)
  (cond ((< x 0) (- x))
        (else x)))

;Exercise 1.2.
(/(+ 5 4(- 2(- 3 (+ 6 (/ 4 5)))))
  (* 3(- 6 2)(- 2 7)))

;todo excercise 1.3