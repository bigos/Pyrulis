(defun divisors (n)
  (loop for x from 2 to (sqrt n )
     if (zerop (mod n x)) collect (cons x (/ n x))
     do
       (when (zerop (mod x 10000000)) (format t "~g      " (/ x  (/ (1+ n) 2))))))

(defparameter *z* '( (71 . 8462696833) (839 . 716151937) (1471 . 408464633) (6857 . 87625999)
                    (59569 . 10086647) (104441 . 5753023) (486847 . 1234169) ))

(defun solution ()
  (loop for x in *z*
     do
       (format t "~s ~s~%" (car x) (divisors (car x)))
       (format t "~s ~s~%" (cdr x) (divisors (cdr x)))))
