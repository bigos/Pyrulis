(defsystem sgf-analyser
  :serial t
  :version "0.0.1"
  :author "Jacek Podkanski"
  :licence "GPLv3"
  :depends-on (:esrap
               :alexandria
               :serapeum)
  :components ((:file "packages")
	       (:module "libraries"
			:components ((:file "sgf-importer")
				     (:file "board-coordinates")))
	       (:file "sgf-analyser"))
  :description "*.sgf file analyser"
  :long-description "Analyser of Go games in *.sgf format"
)
