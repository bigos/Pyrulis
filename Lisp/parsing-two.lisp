;;; parsing TWO - playing with the parsing basics

(declaim (optimize (speed 0) (safety 2) (debug 3)))

(ql:quickload :alexandria)

(defpackage #:parsing-two
  (:use #:cl))

(in-package #:parsing-two)              ;---------------------------------------

(defun data ()
  (format nil " 123 + 456 # comment"))

;;; character extraction

(defun at (string index)
  "STRING character at index"
  (aref string index))

;;; character consumption

(defun consume (data index predicates)
  "take character from DATA at INDEX and return on the first of PREDICATES
  giving ok or error"
  (if (null predicates)
      (list 'error (at data index))
      (if (funcall (first predicates) (at data index))
          (list 'ok (at data index))
          (consume data index (cdr predicates)))))
