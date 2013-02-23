(defpackage #:sgf-analyser
  (:use :cl :asdf)
  (:export :run))

(defpackage #:sgf-importer 
  (:use :common-lisp)
  (:export :get-move-list))
