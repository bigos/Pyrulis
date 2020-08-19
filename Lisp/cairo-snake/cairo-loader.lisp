;;; loader for starting from the command line

(defparameter project-system-path
  (if
   (eq :os-windows (uiop/os:detect-os))
   #p"c:/Users/Jacek/Documents/Programming/Pyrulis/Lisp/cairo-snake/"
   #p"~/Programming/Pyrulis/Lisp/cairo-snake/"))

(push project-system-path asdf:*central-registry*)
(ql:quickload :cairo-snake)
(in-package :cairo-snake)
(main)

(when
    (equal (lisp-implementation-type) "SBCL")
  (sb-ext:exit))
