;;;; wikiview.asd

(asdf:defsystem #:wikiview
  :description "Describe wikiview here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :depends-on (#:parenscript
               #:cl-who #:hunchentoot  #:cl-fad #:css-lite)
  :serial t
  :components ((:file "package")
               (:file "wikiview")))
