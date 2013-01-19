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

(defun header-value (key)  
  (let ((kv (assoc key (car *all-moves*) :test #'equalp)))
    (if (listp (cdr kv))
	(car (cdr kv))
	(cdr kv))))

(defun game-stats ()
  (let ((stats `(("white" . "PW") ("white rank" . "WR") ("black" . "PB") ("black rank" . "BR") ("~%board size" . "SZ") 
		 ("rules" . "RU") ("result" . "RE") ("komi" . "KM") ("~%handicap" . "HA")
		 ,(cond  ((length (header-value "AB"))  '("black handicap list" . "AB")) 
			 ((length (header-value "AW"))  '("white handicap list" . "AW"))))))
    (dolist (el stats)
      ;; ~? explanation: http://www.lispworks.com/documentation/HyperSpec/Body/22_cgf.htm
      (format t "~@?: ~S   "  (car  el)   (header-value (cdr el))))))

(defun add-handicaps ()
  (dolist (handis `(("black" ,(header-value "AB")) ("white" ,(header-value "AW"))))
    (dolist (pos (cadr handis))
      (format t "#### going to place ~A at ~A ~%" (car handis) pos))))
 
(defun print-board ()
  (format t "~%~%going to print the board~%"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun main ()        
  (let ((grid) (grid-size))
    (format T "~%~%~A <<<<<<<<<<~%" *all-moves*)   
    (game-stats )
    (setf grid-size (parse-integer (header-value "SZ")))
    (format t "~%~d <<< grid size ~%" grid-size)
    (setf grid (make-array (list grid-size grid-size) :initial-element nil))
    (setf (aref grid 18 18) "zzz")	;setting element of the array
    ;(format t "~A ~%" grid)    
    ;;sample char2int
    (loop for x from (char-code #\a) to (char-code #\s) do
	 (format t "~s ~s ~s    " x (- x 97) (code-char x)))
					;get char from str
    (format t "~% :~s:   ~%"  (char "abc" 1))
    
    (add-handicaps)
    ;print the board
    (print-board)

    ))

;;;==================================================
(in-package :cl-user)
(sgf-analyser:main)
