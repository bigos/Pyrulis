;;;; TestAppWikipediaViewer.asd

(asdf:defsystem #:testappwikipediaviewer
  :description "Describe TestAppWikipediaViewer here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :serial t
  :depends-on (:hunchentoot :cl-who :parenscript :cl-fad :css-lite)
  :components ((:file "package")
               (:file "testappwikipediaviewer")))
