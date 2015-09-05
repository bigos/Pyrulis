;; https://chriskohlhepp.wordpress.com/convergence-of-modern-cplusplus-and-lisp/

(declaim (optimize (speed 3) (safety 0) (space 0) (debug 3)))

(defun foo (x y)
  (logxor x y))

(defun bar (x y)
  (declare (type (integer 0 255) x y))
  (+ (logior x 1) (logior y 2)))

(defun wrong-me ()
  (bar "wrong" 'me))
