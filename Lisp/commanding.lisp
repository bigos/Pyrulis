(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(alexandria defclass-std)))

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
  runtime
  command
  model
  view
  runtime
  repl_print
|#

(defclass/std runtime ()
  ((model)))

(defparameter *runtime* (make-instance 'runtime))

(defmethod init ((runtime runtime) flags)
  (declare (ignore flags))
  (setf (model runtime)
        nil))

(defmethod view ((runtime runtime) model)
  (warn "view ~S~%" model)
  ;;  do the view stuff

  (print-to-repl runtime))

(defmethod update ((runtime runtime) message model)
  (warn "update ~S ~S~%" message model)
  (cond
    ((eq message :help)
     (view runtime model))
    (t (warn "not implemented ~S ~S~%" message model)
       (view runtime model))))

(defmethod print-to-repl ((runtime runtime) )
  (warn "finally I will print to REPL~&"))

;; (command *runtime* "boo")
(defmethod command ((runtime runtime) input)
  (format t "handling command ~S~%" input)

  (cond
    ((eq input '|help|)
     (warn "no help yet written")
     (update runtime :help (model runtime)))

    (T
     (warn "input ~S not handled" input))))

(defun main ()
  (init *runtime* nil)

  (loop for input = (prompt "enter command")
        do
           (format t "you have said ~S~%" input)
           (command *runtime* input)
        until (eq input '|quit|)
        finally
           (format t "quitting~%")))
