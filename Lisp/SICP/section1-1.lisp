;; 1.1.6  Conditional Expressions and Predicates

; Excercise 1.3

(defun two-larger (a b c)
  (if  (> a b)
       (cons a (max b c))
       (cons b (max a c))))

(defun sum-larger-squares (a b c)
  (let ((tl (two-larger a b c)))
    (+ (expt (car tl) 2)
       (expt (cdr tl) 2))))

;; Exercise 1.4
(defun a-plus-abs-b (a b)
    (funcall (if (> b 0) #'+ #'-) a b))

;;Exercise 1.5

(defun p () (funcall #'p))

(defun test (x y)
    (if (= x 0)
        0
        (funcall y)))

;; 1.1.7  Example: Square Roots by Newton's Method

(defun average (x y)
  (/ (+ x y) 2))

(defun square (x) (* x x))

(defun good-enough? (guess x)
    (< (abs (- (square guess) x)) 0.001))

(defun improve (guess x)
    (average guess (/ x guess)))

(defun sqrt-iter (guess last-guess x)
  (format t "~S " (- guess last-guess))
  (if (< (abs (- guess last-guess)) 0.0001)
        guess
        (sqrt-iter (improve guess x)
                   guess
                   x)))

(defun my-sqrt (x)
    (sqrt-iter 1.0 0 x))

;; Exercise 1.8
(defun cube-sqrt (x)
  (loop
     for guess = 1.0 then (/
                         (+
                          (/ x (square guess))
                          (* 2 guess))
                         3)
     and last-guess = 0 then guess
     for diff = (abs (- guess last-guess))
     until (< diff 0.001)
     finally (return guess)))

;; 1.1.8  Procedures as Black-Box Abstractions
