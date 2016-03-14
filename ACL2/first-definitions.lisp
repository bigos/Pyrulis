;;; definitions on page 33

(in-package "ACL2")

(defun pair (x y)
  (cons x (cons y '())))

(defun first-of (x)
  (car x))

(defun second-of (x)
  (car (cdr x)))

(dethm first-of-pair (a b)
       (equal (first-of (pair a b)) a))
