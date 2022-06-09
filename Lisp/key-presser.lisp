(declaim (optimize (spped 1) (safety 2) (debug 3)))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(alexandria serapeum defclass-std)))

;;; * package %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
(require 'sb-concurrency)

(defpackage :key-presser
  (:use #:cl))
;; (load "/home/jacek/Programming/Pyrulis/Lisp/key-presser.lisp")
(in-package :key-presser)
