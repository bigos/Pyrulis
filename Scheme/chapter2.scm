#lang planet neil/sicp

(define (factorial n)
  (if (= n 1)
      1
      (* n (factorial (- n 1)))))

;recursive
(define (fib n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (else (+ (fib (- n 1))
                 (fib (- n 2))))))

;iterative
;; (define (fib n)
;;   (fib-iter 1 0 n))

(define (fib-iter a b count)
  (if (= count 0)
      b
      (fib-iter (+ a b) a (- count 1))))

(define (count-change amount)
  (cc amount 5))

(define (cc amount kinds-of-coins)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (= kinds-of-coins 0)) 0)
        (else (+ (cc amount
                     (- kinds-of-coins 1))
                 (cc (- amount
                        (first-denomination kinds-of-coins))
                     kinds-of-coins)))))

(define (first-denomination kinds-of-coins)
  (cond ((= kinds-of-coins 1) 1)
        ((= kinds-of-coins 2) 5)
        ((= kinds-of-coins 3) 10)
        ((= kinds-of-coins 4) 25)
        ((= kinds-of-coins 5) 50)))

;; Exercise 1.11.
;; A function f is defined by the rule that
;; f(n) = n if n<3
;; and f(n) = f(n - 1) + 2f(n - 2) + 3f(n - 3) if n> 3.
;; Write a procedure that computes f by means of a recursive process.
;; Write a procedure that computes f by means of an iterative process.
(define (f n)
  (if (< n 3)
      n
      (+ (* 1 (f (- n 1)))
         (* 2 (f (- n 2)))
         (* 3 (f (- n 3))))))

(define (g n)
  (if (< n 3)
      n
      (g-iter 2 1 0 n)))


(define (fiter n x)
  (* x (f (- n x))))

(define (g-iter a b c count)
  (if (< count 3)
      a
      (g-iter (+ (* 1 a) (* 2 b) (* 3 c))
              a
              b
              (- count 1))))

;; Exercise 1.12.

(define (pascal x y)
  (cond ((= 1 x) 1)
        ((> x y) 0)
        (else (+ (pascal (- x 1) (- y 1))
                 (pascal x (- y 1))))))
;; x -->
;y 1 0 0 0 0
;| 1 1 0 0 0
;| 1 2 1 0 0
;V 1 3 3 1 0
;; 1 4 6 4 1

;; my own recursion and iteration excercise
(define (sr n)
  (if (= n 0)
      n
      (+ n
         (sr (- n 1)))))

(define (sr2 n)
  (sri 1 0 n))

(define (sri x y n)
  (if (> x n)
      y
      (sri (+ 1 x) (+ x y) n)))

; Exercise 1.15
(define (cube x) (* x x x))
(define (p x)
  (begin
    (display " | ")
    (- (* 3 x) (* 4 (cube x)))))
(define (sine angle)
  (if (not (> (abs angle) 0.1))
      angle
      (p (sine (/ angle 3.0)))))
; a - 5
; b - log3(n)

; Exercise 1.16
(define (square x) (* x x))
; recursive version
(define (fast-expt b n)
  (cond ((= n 0) 1)
        ((even? n) (square (fast-expt b (/ n 2))))
        (else (* b (fast-expt b (- n 1))))))
