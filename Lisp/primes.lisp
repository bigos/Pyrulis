;;; primes

(defun remainders (n)
  (loop for x from 1 to n
     collect (list (cond
                     ((equalp (sqrt n) x) "=")
                     ((equalp (floor (sqrt n)) x) " ")
                     (T " "))
                   (rem n x))))


(defun list-remainders (n)
  (loop for x in (remainders n)
     do (format t "~a~2,d " (car x) (cadr x))))

(loop for x from 1 to 150
   do (progn
        (format t "~3,d " x)
        (list-remainders x)
        (terpri)) )
