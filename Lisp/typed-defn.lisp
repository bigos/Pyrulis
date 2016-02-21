(declaim (optimize (speed 3) (safety 0) (space 0) (debug 0)))

;;; this macro misses incorrect result type
(defmacro defn (name types args &rest rest)
  "Type safe defun"
  (let ((types (remove-if
                (lambda (x) (or (equal '-> x) (equal '→ x))) types)))
    `(progn (defun ,name ,args
              ,@(loop for arg in args for type in types
                   collect `(check-type ,arg ,type))
              ,@rest)
            (declaim (ftype (function ,(butlast types) ,@(last types)) ,name)))))

;;; type checked macroized version of defun incorrect handling of result type
(defn one-plus-x (integer -> integer) (x)
  (1+ x))

(defun main ()
  ;; fine
  (princ (one-plus-x 2))
  (terpri)
  ;; type error
  (princ (one-plus-x "three")))
