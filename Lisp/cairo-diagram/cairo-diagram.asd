;;; cairo-diagram.asd

(asdf:defsystem #:cairo-diagram
  :description "Describe cairo-diagram here"
  :author "Jacek Podkanski <your.name@example.com>"
  :license  "Specify license here"
  :depends-on (:cl-cffi-gtk)
  :version "0.0.1"
  :serial t
  :components ((:file "packages")
               (:file "cairo-diagram")))
