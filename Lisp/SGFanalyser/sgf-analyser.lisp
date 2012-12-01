(defvar *app-path* "/home/jacek/Programming/Pyrulis/Lisp/SGFanalyser/")
(defvar *sgf-files-path* (concatenate 'string *app-path* "sgf_files/") )
(defvar *sgf-data-filename* (concatenate 'string *sgf-files-path* "jacekpod-coalburner.sgf"))
(defvar *libraries-path* (concatenate 'string *app-path* "libraries/"))

(defun read-file-to-string (filename)
  (let ((file-content))
    (with-open-file (stream filename)
      (setf file-content (make-string (file-length stream)))
      (read-sequence file-content stream ))   
    file-content ))

;; load libraries
(load (concatenate 'string *app-path* "load.lisp"))

(defun main ()
  (let* ((buffer (read-file-to-string *sgf-data-filename*)) 
	 (all-moves (sgf-importer:get-move-list buffer)))	    			       
    (format T "~%~%~A <<<<<<<<<<~%" all-moves)
    ))

(main)

