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

(defun get-value (kv-list key)
  (let ((kv))
   (setf kv (assoc key kv-list :test #'equalp))
    (if (eq 1 (length (cadr kv))) 
	(caadr kv) 
	(cadr kv))))

(defun header-value (key)
  (get-value *header-data* key))

(defun game-stats ()
  (let ((new-line (format nil "~%"))) 
    (concatenate 'string "white: " (header-value "PW") " " (header-value "WR") " black: " (header-value "PB") " " (header-value "BR")
		 " board size: "  (header-value "SZ") new-line "rules: " (header-value "RU") " result: "  (header-value "RE")
		 " komi: " (header-value "KM") " handicap: " (header-value  "HA") 
		 (cond  ((length (header-value "AB"))  (format nil "~%black handicap list ~S" (header-value "AB")) ) 
			((length (header-value "AW"))  (format nil "~%white handicap list ~S" (header-value "AW")) )
			(T nil)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun main ()        
  (let ((grid) (grid-size))
    (format T "~%~%~A <<<<<<<<<<~%" *all-moves*)    
    (format t ">>>> ~S <<<<<~%" *header-data*)
    (format t "game stats:~%~A~%" (game-stats ))
    (setf grid-size (parse-integer (header-value "SZ")))
    (format t "~d <<< grid size ~%" grid-size)
    (setf grid (make-array (list grid-size grid-size) :initial-element nil))
    (setf (aref grid 18 18) "zzz")	;setting element of the array
    ;;(format t "~A ~%" grid)
    
    ;;sample char2int
    (loop for x from (char-code #\a) to (char-code #\s) do
	 (format t "~s ~s ~s    " x (- x 97) (code-char x)))
					;get char from str
    (format t "~% :~s:   "  (char "abc" 1))
    ))

;;;==================================================
(in-package :cl-user)
(sgf-analyser:main)
