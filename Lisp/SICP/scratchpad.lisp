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

(defun sqr (n &optional (guess 0) (tolerance n))
  (if (> *counter* 20)
      (error "finished")
      (incf *counter*))
  (format t "   ~S ~S " guess tolerance)
  (cond ((good-enough? '< (square guess) n (square tolerance))
         (format t "A")
         (sqr n guess (halve tolerance)))
        ((good-enough? '>= (square guess) n (square tolerance))
         (format t "B")
         (sqr n (halve tolerance) (halve tolerance)))
        (T (error "strange error"))))
