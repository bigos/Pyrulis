;;; parsing ONE - playing with the parsing basics

(declaim (optimize (speed 0) (safety 2) (debug 3)))

(ql:quickload :alexandria)

(defpackage #:parsing-one
  (:use #:cl))

(in-package #:parsing-one)              ;---------------------------------------

(defparameter parsed (format nil
                             " 123 + 456 # comment~% \"a \\\"quoted\\\" String\" ++ \"777\"  # end comment"))

(defun main ()
  (format t "~s~%" parsed))

;;; ----------------------------------------------------------------------------
(main)
