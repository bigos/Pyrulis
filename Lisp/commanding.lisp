(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(alexandria)))

(defpackage #:commanding
  (:use #:cl))

;; (load "~/Programming/Pyrulis/Lisp/commanding.lisp")
(in-package #:commanding)

(defun prompt (prompt)
  (format t "~&~a > " prompt)
  (read-line))

(defun coms ()
  (list "quit" "help"))

(defun command (input)
  (format t "commanding ~S~%" input)
  (cond
    ((and (equal input "quit")
          (car (member "quit" (coms) :test #'equal)))
     (error "should not end here because of quitting in the main loop"))
    ((and (equal input "help")        ;figure out ensuring correctness
          (car (member "help" (coms) :test #'equal)))
     (format t "commands are ~S~%" (list "quit" "help")))
    (T
     (error "unrecognised command ~S~%" input))))

(defun main ()
  (loop for input = (prompt "enter command")
        until (equal input "quit")
        do
           (format t "you have said ~S~%" input)
           (command input)
        finally
           (format t "quitting~%")))
