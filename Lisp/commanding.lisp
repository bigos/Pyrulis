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



(defun main ()
  ;; (init)

  (loop for input = (prompt "enter command")
        do
           (format t "you have said ~S~%" input)
           ;; (command input)
        until (equal input "quit")
        finally
           (format t "quitting~%")))
