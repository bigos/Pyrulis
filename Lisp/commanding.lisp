(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(alexandria)))

(defpackage #:commanding
  (:use #:cl))

;; (load "~/Programming/Pyrulis/Lisp/commanding.lisp")
(in-package #:commanding)

(defparameter *model* nil)


(defun prompt (prompt)
  (format t "~&~a > " prompt)
  (read-line))

(defun coms () (list "quit" "help"))

(defun command (input)
  (format t "commanding ~S~%" input)
  (labels ((is (com)
             (and (equal input com)
                  (car (member com (coms) :test #'equal)))))
    (cond
      ((is "quit")
       (error "should not end here because of quitting in the main loop"))
      ((is "help")
       (format t "commands are ~S~%" (list "quit" "help")))
      (T
       (error "unrecognised command ~S~%" input))))
  (view))

(defun view ()
  (format t "~&starting view ====++============~%")

  (format t "~&finished view ==================~%")
  nil)

(defun main ()
  (loop for input = (prompt "enter command")
        until (equal input "quit")
        do
           (format t "you have said ~S~%" input)
           (command input)
        finally
           (format t "quitting~%")))
