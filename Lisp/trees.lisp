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

;;; parsing links
;; https://github.com/vsedach/Vacietis/blob/master/compiler/reader.lisp
;; https://stackoverflow.com/questions/21185879/writing-a-formal-language-parser-with-lisp

;;; list to cons
(defun list-conser (list)
  (labels
      ((conser (fn l)
         (let ((el (funcall fn l)))
           (if (atom el)
               (if (symbolp el)
                   (list 'quote el)
                   el)
               (list-conser el)))))
    (list 'cons
          (conser 'car list)
          (conser 'cdr list))))
