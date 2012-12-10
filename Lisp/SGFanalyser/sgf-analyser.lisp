;;; define application package
(defpackage :sgf-analyser
  (:use :common-lisp ) 
  (:export :main))

(in-package :sgf-analyser)

;;; define game data related global variables
(defvar *app-path* "/home/jacek/Programming/Pyrulis/Lisp/SGFanalyser/")
(defvar *libraries-path*    (concatenate 'string *app-path* "libraries/"))
(defvar *sgf-data-filename* (concatenate 'string *app-path* "game_records/" "jacekpod-coalburner.sgf"))
 
;;; load libraries
(load (concatenate 'string *app-path* "load.lisp"))

;;; other global variables
(defparameter *all-moves*  (sgf-importer:get-move-list *sgf-data-filename*))
(defparameter *header-data* (car *all-moves*))

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

(defun game-stats (header-data)
  (let ((stats "")) 
    (concatenate 'string stats "white: " (get-value header-data "PW") " black: " (get-value header-data "PB") )
    (concatenate 'string stats "board size: "  (get-value header-data "SZ") " rules: " (get-value header-data "RU") " result: "  (get-value header-data "RE"))
    (format nil "~S" stats)
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun main ()
  (let* ( (header-data))      
    (format T "~%~%~A <<<<<<<<<<~%" *all-moves*)    
    (format t ">>>> ~S <<<<<~%" *header-data*)
    (format t "~S +++++++++++++++++~%" (get-value *header-data* "RE"))
    (format t "game stats: ~S~%" (game-stats *header-data*))
    ))

;;;==================================================
(in-package :cl-user)
(sgf-analyser:main)
