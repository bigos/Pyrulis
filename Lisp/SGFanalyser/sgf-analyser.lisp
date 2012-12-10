;;; define application package
(defpackage :sgf-analyser
  (:use :common-lisp ) 
  (:export :main))

(in-package :sgf-analyser)

;;; define global variables
(defvar *app-path* "/home/jacek/Programming/Pyrulis/Lisp/SGFanalyser/")
(defvar *libraries-path*    (concatenate 'string *app-path* "libraries/"))
(defvar *sgf-data-filename* (concatenate 'string *app-path* "game_records/" "jacekpod-coalburner.sgf"))
 
;;; load libraries
(load (concatenate 'string *app-path* "load.lisp"))

(defun find-kv (kv-list key)
  (dolist (kv kv-list)
    (if (equal key (car kv))
	(return kv))))

(defun get-v-part (kv)
  (if (eq 1 (length (cadr kv))) 
      (caadr kv) 
      (cadr kv)))

(defun get-value (kv-list key)
  (get-v-part (find-kv kv-list key)))

(defun header-info (kv-list)
  (let ((f))
    (dolist (el kv-list)
      (format T "!!!> ~S~%" el))
    (format T "~S~%"    (get-value kv-list "AB"))
    (format T "~S~%"    (get-value kv-list "RU"))
    ))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun main ()
  (let* ((all-moves))  
    (setf all-moves (sgf-importer:get-move-list *sgf-data-filename*))
    (format T "~%~%~A <<<<<<<<<<~%" all-moves)
    (header-info (car all-moves))
    ))

;;;==================================================
(in-package :cl-user)
(sgf-analyser:main)
