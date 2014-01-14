(defun consed-divisors (n)
   (loop for x from 2 to (sqrt n )
          if (zerop (mod n x)) collect (cons x (/ n x))))

(defun divisors (n)
  (let ((cc (consed-divisors n)) (a) (b))
    (dolist (x cc)
      (if (= (car x) (cdr x))
          (push (car x) a)
          (progn
            (push (car x) a)
            (push (cdr x) b))))
    (append (reverse a) (reverse b))))

(defparameter *z* (divisors 600851475143))

(defun solution ()
  (loop for x in *z*
     do
       (format t "~s ~s~%"  x (divisors  x))))
