
(defun read-file-to-string (filename)
  (let ((file-content))
    (with-open-file (stream filename)
      (setf file-content (make-string (file-length stream)))
      (read-sequence file-content stream ))   
    file-content ))

(defvar *app-path* "/home/jacek/Programming/Pyrulis/Lisp/SGFanalyser/")
(defvar *sgf-files-path* (concatenate 'string *app-path* "sgf_files/") )
(defvar *data-filename* (concatenate 'string *sgf-files-path* "jacekpod-coalburner.sgf"))
(defvar *libraries-path* (concatenate 'string *app-path* "libraries/")) 

(defpackage :sgf-importer 
  (:use :common-lisp)
  (:export :get-move-list))
(load (concatenate 'string *libraries-path* "sgf-importer.lisp"))

(defun main ()
  (let* ((buffer (read-file-to-string *data-filename*)) (all-moves (sgf-importer:get-move-list buffer)) )	    			       
    (format T "~%~%~A <<<<<<<<<<~%" all-moves)
    ))

(main)

