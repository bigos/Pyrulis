;;;; lisp-c-gtk.asd

(asdf:defsystem #:lisp-c-gtk
  :description "Describe lisp-c-gtk here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (:cffi)
  :components ((:file "package")
               (:file "lisp-c-gtk")))
