;;; define package for the chapter

;;; p 5 example
(defun divides (d n)
  (eq (rem n d)
      0))

(defun ld (n)
  (ldf 2 n))

(defun ldf (k n)
  (cond ((divides k n)
         k)
        ((> (* k k)
            n)
         n)
        (T (ldf (1+ k)
                n))))

;;; exercise 1.4 p 8

(defun prime0 (n)
  (cond ((< n 1)
         (error "not a positive integer"))
        ((eq n 1)
         nil)
        (T (eq (ld n)
               n))))

;;; skipped lots of irrelevant stuff

;;; page 13 playing the Haskell game

(defun min-int (a)
  (cond ((null a)
         (error "empty list"))
        ((null (cdr a))
         (car a))
        (T (min (car a)
                (min-int (cdr a))))))

;;;
exercise 1.9
(defun max-int (a)
  (cond ((null a)
         (error "empty list"))
        ((null (cdr a))
         (car a))
        (T (max (car a)
                (max-int (cdr a))))))

;;;
exercise 1.10 p 14
