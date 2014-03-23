(declaim (optimize (debug 3) (safety 3)))

(defun good-enough? ( result expected tolerance)
  ;;(format t "~&trying ~f ~f ~f ~f~%" operator result expected tolerance)
  (< (abs (- expected result)) tolerance))

(defun average (min max) (/ (+ min max) 2))
(defun square (n) (* n n))
(defparameter *counter* 10)

(defun sqr (n &optional (guess 0) (tolerance n))
 ;; (format t "~& ~f ~f  " guess tolerance)
  (/ 2 0)
  (cond ((eq (square guess) n) guess)
        ((good-enough? (square guess) n 0.01) (average guess tolerance))
        ((> (square guess) n)
         (sqr n (average guess 0) (average guess tolerance)))
        (T
         (sqr n (average guess tolerance) tolerance))))
