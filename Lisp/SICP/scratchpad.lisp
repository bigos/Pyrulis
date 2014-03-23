;; my experiment with calculating square root

(defun good-enough? (operator result expected tolerance)
  (format t "~&trying ~f ~f ~f ~f~%" operator result expected tolerance)
  (and
   (funcall operator expected result)
   (< (abs (- expected result)) tolerance)))

(defun average (min max) (/ (+ min max) 2))
(defun square (n) (* n n))
(defun halve (n) (/ n 2))

(defparameter *counter* 10)

(defun sqr (n &optional (guess-low 0) (guess-high n))
  (if (> *counter* 20)
      (error "finished")
      (incf *counter*))
  (format t "   ~f ~f " guess-low guess-high)
  (cond ((< (square guess-high) n)
         (format t "a")
         (sqr n (* 2 guess-low) guess-high))
        ((>= (square guess-high) n)
         (format t "b")
         (sqr n guess-low (halve guess-high)))
        (T (format t "~&~S ~S " guess-low guess-high)
           (error "strange error"))))
