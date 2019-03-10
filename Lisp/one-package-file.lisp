(ql:quickload (list :alexandria :fiveam) :silent T)

(defpackage #:one-file
  (:use #:cl))

(in-package #:one-file)

(format T "Hello Lisp~%")
