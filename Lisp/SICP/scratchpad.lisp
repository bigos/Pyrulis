;; my experiment with calculating square root

(defun good-enough? (result expected tolerance)
  (<= (- expected result) tolerance))

(defun sqr (n &optional (guess 0))
  (format t "~S    " guess)
  (cond ((zerop n) 0)
        ((eq 1 n) 1)
        ((good-enough? (* guess guess) n 0.01) guess)
        (T (sqr n (+ 0.01 guess)))))
