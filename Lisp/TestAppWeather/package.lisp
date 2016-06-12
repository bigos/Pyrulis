;;;; package.lisp

(defpackage #:test-app-weather
  (:use #:cl #:cl-who #:hunchentoot #:parenscript)
  (:export :run :stop))
