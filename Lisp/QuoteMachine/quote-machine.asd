(defsystem #:quote-machine
  :serial t
  :version "0.0.1"
  :author "Jacek Podkanski"
  :licence "GPLv3"
  :depends-on (:hunchentoot :cl-who :parenscript :cl-fad :css-lite)
  :components ((:file "packages")
               (:file "quote-machine"))
  :description "quote machine"
  :long-description "quote machine for free code camp")
