;;; even with safety set to 0 sbcl gives warning
(declaim (optimize (speed 3) (safety 3) (space 0) (debug 0)))

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
;;; first following example misses result type errors
;; http://ahungry.com/blog/2015-07-10-Type-Safety-and-Lack-Thereof.html
;; and
;; http://nklein.com/2009/06/optimizing-lisp-some-more/
;; aspecially one comment about optimisations
