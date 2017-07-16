;;; example from: http://shrager.org/llisp/13.html

;;; tree example

;;; list version
'((MARY HAD A) (LITTLE (LAMBDA)))

;;; cons versions
(cons (cons 'mary
            (cons 'had
                  (cons 'a
                        nil)))
      (cons (cons 'little
                  (cons (cons 'lambda
                              nil)
                        nil))
            nil))

;;; simple list

;;; list version
'(a list)

;;; cons version
(cons 'a
      (cons 'list
            nil))

;;; list to cons
(defun list-conser (list)
  (labels
      ((conser (fn l)
         (let ((el (funcall fn l)))
           (if (atom el)
               el
               (list-conser el)))))
    `(cons ,(conser 'car list)
           ,(conser 'cdr list))))
