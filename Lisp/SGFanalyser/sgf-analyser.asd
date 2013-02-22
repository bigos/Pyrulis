;;;asdf will go here


(in-package :cl-user)

(defpackage sgf-analyser
  (:use :cl :asdf)
  (:export :main))

(defpackage :sgf-importer 
  (:use :common-lisp)
  (:export :get-move-list))



(in-package :sgf-analyser)

(defsystem sgf-analyser
  :serial t
  :version "0.0.1"
  :author "Jacek Podkanski"
  :licence "GPLv3"
  :components ((:file "sgf-importer") 
	       (:file "sgf-analyser"))
  :description "*.sgf file analyser"
  :long-description "Analyser of Go games in *.sgf format"

)
