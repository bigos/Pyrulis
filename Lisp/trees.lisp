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
  `(cons ,(if (atom (car list))
              (car list)
              (list-conser (car list)))
         ,(if (atom (cdr list))
              (cdr list)
              (list-conser (cdr list)))))
