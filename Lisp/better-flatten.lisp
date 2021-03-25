;;; better flatten with recursion on accumulator

(defun flatten (x &optional acc)
  (if (atom x)
      (cons x acc)
      (flatten (car x)
               (if (null (cdr x))
                   acc
                   (flatten (cdr x) acc)))))

(format t "~A~%"
        (flatten (cons (cons 1 2) (cons (list 3.1 nil 3.2 3.3) 4))))
