;;; definitions on page 33



(defun pair (x y)
  (cons x (cons y '())))

(defun first-of (x)
  (car x))

(defun second-of (x)
  (car (cdr x)))

(defthm first-of-pair
       (equal (first-of (pair a b))
              a))
(verify (equal (append (append x y) z)
                      (append x (append y z))))
