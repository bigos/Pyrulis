(defun palindromep (n)
  (let ((ns (format nil "~a" n)))
    (equal ns (reverse ns))))

(defun dig-3-products ()
  (let ((r))
    (loop for x from 111 to 999 do
         (loop for y from 111 to 999 do
              (push (* x y) r)))
    (reverse r)))

(princ (loop for n in (dig-3-products)
          if (palindromep n) maximizing n))
