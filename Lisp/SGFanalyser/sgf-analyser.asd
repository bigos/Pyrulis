;;;asdf will go here


(in-package :cl-user)
(defpackage sgf-analyser-asd
  (:use :cl :asdf))
(in-package :sgf-analyser-asd)

(defsystem sgf-analyser
  :version "0.0.1"
  :author "Jacek Podkanski"
  :licence "GPLv3"
  :components ((:module "libraries"
			:components ((:file "sgf-importer") 
				     (:file "board-coordinates")))
	       (:file "sgf-analyser"))
  :description "*.sgf file analyser"
  :long-description "Analyser of Go games in *.sgf format"
)
