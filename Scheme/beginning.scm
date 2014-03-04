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

(define (sum-of-2-largest-of-3 a b c)
  (+(max a b)
    (max b c))) 
  
(define (average x y)
  (/ (+ x y) 2))

(define (improve guess x)
  (average guess (/ x guess)))

(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x)
                 x)))

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.01))

(define (sqrt x)
  (sqrt-iter 1.0 x))

; todo excercise 1.8 unfinished
(define (cube-sqrt x)
  (cube-sqrt-iter 1.0 x))

(define (cube-sqrt-iter guess x)
  (if (<(abs(-(* guess guess guess)
               x))
         0.01)
      guess
      (cube-sqrt-iter (cube-improve guess x) x)))
;x/y^2+2y/3 - y guess
(define (cube-improve guess x)
  (/ (+ (/ x (* guess guess)) (* 2 guess)) 3))