;;; parsing ONE - playing with the parsing basics

(declaim (optimize (speed 0) (safety 2) (debug 3)))

(ql:quickload :alexandria)

(defpackage #:parsing-one
  (:use #:cl))

(in-package #:parsing-one)              ;---------------------------------------

(defparameter data (format nil
                           " 123 + 456 # comment~% \"a \\\"quoted\\\" String\" ++ \"777\"  # end comment"))

(defun at (str i)
  (aref str i))

(defun prev (str i)
  (when (> i 0)
    (at str (1- i))))

(defun next (str i)
  (when (< i (1- (length str)))
    (at str (1+ i))))

(defun char-within (c a b)
  (<= (char-code a) (char-code c) (char-code b)))

(defun char-member (c l)
  (member c l))

(defun main ()
  (format t "~a~%" parsed))

;;; ----------------------------------------------------------------------------
(main)
