;;; define global variables
(defvar *app-path* "/home/jacek/Programming/Pyrulis/Lisp/SGFanalyser/")
(defvar *libraries-path*    (concatenate 'string *app-path* "libraries/"))
(defvar *sgf-data-filename* (concatenate 'string *app-path* "game_records/" "jacekpod-coalburner.sgf"))
 
;;; load libraries
(load (concatenate 'string *app-path* "load.lisp"))

(defun get-val (kv-list key)
  (dolist (el kv-list)
    (if (equal key (car el))
	(return el))))

(defun format-data (g)
  (format T "^^^^^ ~S !!! ~S <> ~S ^^^^ ~A ^^^^~%" g (car g) (cadr g) (length (cadr g))))

(defun header-info (kv-list)
  (let ((f))
    (dolist (el kv-list)
      (format T "!!!> ~S~%" el))
    (format-data (get-val kv-list "AB"))
    (format-data (get-val kv-list "RU"))
    ))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun main ()
  (let* ((all-moves))  
    (setf all-moves (sgf-importer:get-move-list *sgf-data-filename*))
    (format T "~%~%~A <<<<<<<<<<~%" all-moves)
    (header-info (car all-moves))
    ))

(main)
