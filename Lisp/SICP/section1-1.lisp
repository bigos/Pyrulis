; Excercise 1.3

(defun two-larger (a b c)
  (if  (> a b)
       (cons a (max b c))
       (cons b (max a c))))

(defun sum-larger-squares (a b c)
  (let ((tl (two-larger a b c)))
    (+ (expt (car tl) 2)
       (expt (cdr tl) 2))))
