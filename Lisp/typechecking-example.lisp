;;; even with safety set to 0 sbcl gives warning
(declaim (optimize (speed 3) (safety 0) (space 0) (debug 0)))

;;; lisp version of type signature
(declaim (ftype (function (integer) (integer))
                one-plus-x))
;;; function
(defun one-plus-x (x) (1+ x))

(defun main ()
  ;; fine
  (princ (one-plus-x 2))
  (terpri)
  ;; type error
  (princ (one-plus-x "two")))

;; also check
;; (ql:quickload :cl-quickcheck)        
