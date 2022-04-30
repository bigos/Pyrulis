(asdf:defsystem #:graph-viewer
  :description "This is a visualiser that uses graphviz."
  :author "Jacek Podkanski <ruby.object@googlemail.com>"
  :license  "Public domain"
  :version "0.0.1"
  :depends-on (#:alexandria #:serapeum)
  :serial t
  :components ((:file "package")
               (:file "graph-viewer")))
