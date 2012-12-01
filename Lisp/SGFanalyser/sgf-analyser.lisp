(defvar *app-path* "/home/jacek/Programming/Pyrulis/Lisp/SGFanalyser/")
(defvar *sgf-files-path* (concatenate 'string *app-path* "sgf_files/") )
(defvar *sgf-data-filename* (concatenate 'string *sgf-files-path* "jacekpod-coalburner.sgf"))
(defvar *libraries-path* (concatenate 'string *app-path* "libraries/"))

;; load libraries
(load (concatenate 'string *app-path* "load.lisp"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun main ()
  (let* ((all-moves (sgf-importer:get-move-list *sgf-data-filename*)))
    (format T "~%~%~A <<<<<<<<<<~%" all-moves)
    ))

(main)

