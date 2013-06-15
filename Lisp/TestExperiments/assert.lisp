

(defun double-safely (x) 
  (assert (numberp x) (x) (format nil " ~s it's not a number" x))
  (+ x x))

(double-safely 4) 

