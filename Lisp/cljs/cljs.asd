;;;; cljs.asd

(asdf:defsystem #:cljs
  :serial t
  :description "Describe cljs here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :depends-on (#:hunchentoot
               #:cl-who
               #:parenscript
               #:cl-fad)
  :components ((:file "package")
               (:file "cljs")))

