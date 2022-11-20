(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(alexandria serapeum defclass-std)))

(defpackage #:commanding
  (:import-from :defclass-std :defclass/std)
  (:use #:cl))

;; (load "~/Programming/Pyrulis/Lisp/commanding.lisp")
(in-package #:commanding)

(defun prompt (prompt)
  (format t "~&~a > " prompt)
  (alexandria:symbolicate
   (read-line)))

(defun mkstr (&rest args)
  (with-output-to-string (s)
    (dolist (a args) (princ a s))))

(defun symb (&rest args)
  (values (intern (apply #'mkstr args))))


#| command succession
  repl_input
  update message model
  view model
  repl_print
|#

(defmethod print-object ((obj standard-object) stream)
  (print-unreadable-object (obj stream :type t)
    (format stream "~S"
            (loop for sl in (sb-mop:compute-slots (class-of obj))
                  collect (list
                           (sb-mop:slot-definition-name sl)
                           (slot-value obj (sb-mop:slot-definition-name sl)))))))

(defclass/std runtime ()
  ((model)))

(defclass/std model ()
  ())

(defclass/std message ()
  ())

(defclass/std help (message)
  ())


(defmethod init ((runtime runtime) flags)
  (declare (ignore flags))
  (setf (model runtime)
        (make-instance 'model)))

(defmethod print-to-repl ((runtime runtime) )
  (warn "finally I will print to REPL~&"))

(defmethod view ((runtime runtime) model)
  (warn "view ~S~%" model)
  ;;  do the view stuff

  (print-to-repl runtime))

(defmethod update ((runtime runtime) message model)
  (warn "update ~S ~S~%" message model)
  (typecase message
    (help
     (warn "update handling help")
     (view runtime model))
    (t
     (warn "not implemented ~S ~S~%" message model)
       (view runtime model))))

(defmethod command ((runtime runtime) input)
  (format t "handling command ~S~%" input)
  (case input
    ('|help| (update runtime (make-instance 'help) (model runtime)))
    (otherwise (warn "not handled case"))))

(defun main ()
  (let ((runtime (make-instance 'runtime)))
    (init runtime nil)

    (loop for input = (prompt "enter command")
          do
             (format t "you have said ~S~%" input)
             (command runtime input)
          until (eq input '|quit|)
          finally
             (format t "quitting with ~S~%" runtime))))
