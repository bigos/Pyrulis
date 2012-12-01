(defvar *app-path* "/home/jacek/Programming/Pyrulis/Lisp/SGFanalyser/")
(defvar *libraries-path*    (concatenate 'string *app-path* "libraries/"))
(defvar *sgf-data-filename* (concatenate 'string *app-path* "sgf_files/" "jacekpod-coalburner.sgf"))


;; load libraries
(load (concatenate 'string *app-path* "load.lisp"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun main ()
  (let* ((all-moves (sgf-importer:get-move-list *sgf-data-filename*)))
    (format T "~%~%~A <<<<<<<<<<~%" all-moves)
    ))

(main)

