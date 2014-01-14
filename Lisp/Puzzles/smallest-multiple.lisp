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

(defun solution ()
  (loop for n from 0 by 20
     for divs = (divisors n)
     ;; do (format t "~s  " n)
     until  (search '(2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20) divs)
     finally (return n)
       ))
