;; compilation stage type warnings
;; $ sbcl --eval '(compile-file "./mod-safety.lisp")'

;; (defmacro defn (name types args &rest rest)
;;   "Type safe defun"
;;   (let ((types (remove-if
;;                 (lambda (x) (or (equal '-> x) (equal '→ x))) types)))
;;     `(progn (defun ,name ,args
;;               ,@(loop for arg in args for type in types
;;                    collect `(check-type ,arg ,type))
;;               ,@rest)
;;             (declaim (ftype (function ,(butlast types) ,@(last types)) ,name)))))

(declaim (ftype (function (integer integer) (symbol))
                my-mod))

(defun my-mod  (a b)  ;declaring incorrect results gives compile error
  (mod a b))

(defun call-my-mod ()
  (my-mod 7 3))                       

(princ (call-my-mod))
(terpri)
