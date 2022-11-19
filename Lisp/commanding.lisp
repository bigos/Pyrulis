(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(alexandria defclass-std)))

(defpackage #:commanding
  (:import-from :defclass-std :defclass/std)
  (:use #:cl))

;; (load "~/Programming/Pyrulis/Lisp/commanding.lisp")
(in-package #:commanding)

(defparameter *model* nil)

(defun prompt (prompt)
  (format t "~&~a > " prompt)
  (read-line))

#| command succession
  repl_input
  runtime
  command
  model
  view
  runtime
  repl_print
|#

(defclass/std runtime () ())

(defparameter *runtime* (make-instance 'runtime))

;; (command *runtime* "boo")
(defmethod command ((runtime runtime) input)
  (format t "handling command ~S~%" input)

  (cond
    ((equal input "help")
     (warn "no help yet written"))
    (T
     (warn "input ~S not handled" input))))


(defun main ()

  (loop for input = (prompt "enter command")
        do
           (format t "you have said ~S~%" input)
           (command *runtime* input)
        until (equal input "quit")
        finally
           (format t "quitting~%")))
