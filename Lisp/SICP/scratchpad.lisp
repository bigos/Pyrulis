;; my experiment with calculating square root

(defun good-enough? (result expected tolerance)
  (<= (- expected result) tolerance))

(defun sqr (n &optional (guess 0) (tolerance 1))
  (format t "~S ~S     " guess tolerance)
  (cond ((zerop n) 0)
        ((eq 1 n) 1)
        ((good-enough? (* guess guess) n 0.01) guess)
        (T (sqr n (+ tolerance guess) tolerance))))
