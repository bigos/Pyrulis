;;;; cairo-snake.asd

(asdf:defsystem #:cairo-snake
  :description "Describe cairo-snake here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :depends-on (:cl-cffi-gtk)
  :version "0.0.1"
  :serial t
  :components ((:file "package")
               (:file "cairo-snake")))
