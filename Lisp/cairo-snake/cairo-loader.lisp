;;; loader for starting from the command line

;;; on Windows it will be different

(defparameter project-system-path #p "~/Programming/Pyrulis/Lisp/cairo-snake/")

(push project-system-path asdf:*central-registry*)
(ql:quickload :cairo-snake)
(in-package :cairo-snake)
(main)

(when
    (equal (lisp-implementation-type) "SBCL")
  (sb-ext:exit))
