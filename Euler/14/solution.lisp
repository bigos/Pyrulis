;;; 14

(defun next-collatz (n)
  (if (evenp n)
      (/ n 2)
      (1+ (* 3 n))))

(defun collatz (n &optional (a nil))
  (if (eq n 1)
      (cons 1 a)
      (collatz (next-collatz n) (cons n a))))

(defun solve-me ()
  (sort
   (loop for x from 1 below 1000000
      collect
        (list (length (collatz x nil)) x))
   (lambda (x y) (< (car x) (car y)))))
