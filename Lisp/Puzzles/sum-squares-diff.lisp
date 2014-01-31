(defun sum-squares (s e)
  (loop for x from s to e
     sum (expt x 2)))

(defun square-sum (s e)
  (expt (loop for x from s to e
           sum x) 2))

(defparameter *prs* '(11 7 5 3 2 1 ))


(defun more-prs ()
  (loop for x from (+ 2 (car *prs*)) by 2
     until (>= (length *prs*) 10002)
     do
       (unless (divisors x)
         (push x *prs*))))
