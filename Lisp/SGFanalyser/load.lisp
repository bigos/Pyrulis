(defun load-library (name)
  (load (concatenate 'string *libraries-path* name)))

(defpackage :sgf-importer 
  (:use :common-lisp)
  (:export :get-move-list))
(load-library "sgf-importer.lisp")

(defpackage :board-coordinates
  (:use :common-lisp ) 
  (:export :enter))
(load-library "board-coordinates.lisp")
