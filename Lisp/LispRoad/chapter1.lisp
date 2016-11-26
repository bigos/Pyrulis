;;; define package for the chapter

;;; p 5 example
(defun divides (d n)
  (eq (rem n d) 0))

(defun ld (n)
  (ldf 2 n))

(defun ldf (k n)
  (cond ((divides k n) k)
        ((> (expt k 2) n) n)
        (T (ldf (1+ k) n))))

;;; exercise 1.4 p 8
