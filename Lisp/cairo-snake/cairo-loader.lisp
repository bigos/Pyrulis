;;; loader for starting from the command line

(if (equal "LispWorks" (lisp-implementation-type))
    (load "~/lw-rc.lisp"))

(defparameter project-system-path
  (if
   nil                          ; (eq :os-windows (uiop/os:detect-os))
   #p"c:/Users/Jacek/Documents/Programming/Pyrulis/Lisp/cairo-snake/"
   #p"~/Programming/Pyrulis/Lisp/cairo-snake/"))

(push project-system-path asdf:*central-registry*)
(ql:quickload :cairo-snake)
(in-package :cairo-snake)
(main)

(if
 (equal (lisp-implementation-type) "SBCL")
 (sb-ext:exit)
 (quit))
