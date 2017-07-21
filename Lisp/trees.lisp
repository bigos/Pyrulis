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

;;; visualising cons structures
(ql:quickload :draw-cons-tree)
(draw-cons-tree:draw-tree '(if (> 1 2) :gt  :lt))
(draw-cons-tree:draw-tree '(1 . (2 . 3)))


;;; probably simplest grammar
(defparameter source "111+2=3")

(defun num (cursor)
  (let ((ch (subseq source cursor (+ cursor 1))))
    (when (or (equal "1" ch)
              (equal "2" ch)
              (equal "3" ch))
      (+ cursor 1))))

(defun op (cursor)
  (let ((ch (subseq source cursor (+ cursor 1))))
    (when (or (equal "+" ch)
              (equal "=" ch))
      (+ cursor 1))))

(defun gram ()
  (when (integerp (num (op (num (op
                                 (num
                                  (num
                                   (num 0))))))))
      'success))
