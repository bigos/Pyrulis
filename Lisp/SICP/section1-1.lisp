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


;; 1.2.1  Linear Recursion and Iteration
(defun fac (n)
  (* n
     (if (= n 1)
         1
         (fac (1- n)))))

(defun fac-iter (n)
  (loop
     for count from 1
     and last = 1 then  (* count last)
     until (> count n)
     finally (return last)))

; Exercise 1.10
(defun a (x y)
    (cond ((= y 0) 0)
          ((= x 0) (* 2 y))
          ((= y 1) 2)
          (T(a (- x 1)
                   (a x (- y 1))))))

;; 1.2.2  Tree Recursion
(defun fib (n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (T (+ (fib (- n 1))
              (fib (- n 2))))))

(defun fib-iter (n)
  (loop
     for count from 0
     for a = 0 then b
     and b = 1 then (+ a b)
     until (= count n)
     finally (return a)))

;; Example: Counting change
(defun count-change (amount)
  (cc amount 5))

(defun cc (amount kinds-of-coins)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (= kinds-of-coins 0)) 0)
        (T (+ (cc amount
                  (- kinds-of-coins 1))
              (cc (- amount
                     (first-denomination kinds-of-coins))
                  kinds-of-coins)))))

(defun first-denomination (kinds-of-coins)
  (cond ((= kinds-of-coins 1) 1)
        ((= kinds-of-coins 2) 5)
        ((= kinds-of-coins 3) 10)
        ((= kinds-of-coins 4) 25)
        ((= kinds-of-coins 5) 50)))

;; Exercise 1.11
(defun f (n)
  (if (< n 3)
      n
      (+ (* 1 (f (- n 1)))
         (* 2 (f (- n 2)))
         (* 3 (f (- n 3))))))

(defun f-iter (n)
  (if (< n 3)
      n
      (loop
         for count from n downto 2
         for a = 2 then (+ (* 1 a) (* 2 b) ( * 3 c))
         and b = 1 then a
         and c = 0 then b
         finally (return a))))

;; Exercise 1.12
(defun pascal (x y)
    (cond ((= 1 x) 1)
          ((> x y) 0)
          (T (+ (pascal (- x 1) (- y 1))
                (pascal x (- y 1))))))

;; x -->
;;y 1 0 0 0 0
;;| 1 1 0 0 0
;;| 1 2 1 0 0
;;V 1 3 3 1 0
;;  1 4 6 4 1


;; Exercise 1.13
;;TODO

;; 1.2.3  Orders of Growth

;; 1.2.4  Exponentiation
