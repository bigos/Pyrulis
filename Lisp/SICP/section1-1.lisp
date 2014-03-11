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
