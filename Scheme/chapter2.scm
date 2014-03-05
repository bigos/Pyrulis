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

; todo: finish it tomorrow
(define (ff n)
  (if (< n 3)
      n
      (+
       (fiter n 1)
       (fiter n 2)
       (fiter n 3))))

(define (fiter n count)
(if (= 0 count)
n
fiter n (- count 1))
  )
