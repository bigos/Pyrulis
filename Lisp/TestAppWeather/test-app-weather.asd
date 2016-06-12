;;;; test-app-weather.asd

(asdf:defsystem #:test-app-weather
  :description "example test-app-weather for free code camp JavaScript puzzle"
  :author "Jacek Podkanski"
  :license "GPLv3"
  :serial t
  :depends-on (:hunchentoot :cl-who :parenscript :cl-fad :css-lite)
  :components ((:file "package")
               (:file "test-app-weather")))
