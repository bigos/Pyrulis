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

(defun coms () (list "quit" "help" "inspect"))

(defun command (input)
  (format t "commanding ~S~%" input)
  (labels ((is (com)
             (and (equal input com)
                  (car (member com (coms) :test #'equal)))))
    (cond
      ((is "quit")
       (setf  (getf *model* :mode) :quit))
      ((is "help")
       (setf (getf *model* :mode) :help))
      ((is "inspect")
       (setf (getf *model* :mode) :inspect))
      (T
       (error "unrecognised command ~S~%" input))))
  (view))

(defun view ()
  (format t "~&starting view ====++============~%")
  (let ((m (getf *model* :mode)))
    (ecase m
      (:quit (format t "quitting~%"))
      (:help (format t "the commands are ~S~%" (coms)))
      (:inspect (format t "model is: ~S~%" *model*))
      ))

  (format t "~&finished view ==================~%")
  nil)

(defun main ()
  (loop for input = (prompt "enter command")
        do
           (format t "you have said ~S~%" input)
           (command input)
        until (eq :quit (getf *model* :mode))
        finally
           (format t "quitting~%")))
