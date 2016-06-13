;;;; package.lisp

(defpackage #:testappwikipediaviewer
  (:use #:cl #:cl-who #:hunchentoot #:parenscript)
  (:export :run :stop))
