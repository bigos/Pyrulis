(defpackage #:sgf-analyser
  (:use :cl :asdf)
  (:export :main))

(defpackage #:sgf-importer 
  (:use :common-lisp)
  (:export :get-move-list))
