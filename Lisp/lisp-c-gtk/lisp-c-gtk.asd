;;;; lisp-c-gtk.asd
(cl:eval-when (:load-toplevel :execute)
  (asdf:operate 'asdf:load-op 'cffi-grovel))

(asdf:defsystem #:lisp-c-gtk
  :description "Describe lisp-c-gtk here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :defsystem-depends-on ("cffi-grovel")
  :depends-on (:cffi)
  :components ((cffi-grovel:grovel-file "grovel")
               (:file "package")
               (:file "lisp-c-gtk")))
