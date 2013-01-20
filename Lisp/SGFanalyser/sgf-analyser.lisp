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

(defun sgf-to-i (coordinates)
  (labels ((coord (i)
	     (- (char-code(char coordinates i)) 97)))
    (cons (coord 0) (coord 1))))

(defun add-handicaps (board)
  (dolist (handis `(("b" ,(header-value "AB")) ("w" ,(header-value "AW"))))
    (dolist (pos (cadr handis))
      (format t "#### going to place ~A at ~A ~A~%" (car handis) pos (sgf-to-i pos))
      (setf (aref board (car (sgf-to-i pos)) (cdr (sgf-to-i pos))) (car handis))
      )))
 
(defun print-board (board)
  (let ((size (car (array-dimensions board))) (stone) 
	(column-letters '(a b c d e f g h j k l m n o p q r s t)))
    (format t "    ")
    (dolist (c column-letters)
      (format t "~a " c))
    (loop for r from (- size 1) downto 0 do
	 (format T "~&~2d  " (+ r 1))	 
	 (dotimes (c size)
	   (setf stone (aref board r c))
	   (format t "~2a"
		   (if stone 
		       stone 
		       "."))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun main ()        
  (let ((grid) (grid-size))
    (format T "~%~%~A <<<<<<<<<<~%" *all-moves*)   
    (game-stats )
    (setf grid-size (parse-integer (header-value "SZ")))
    (format t "~%~d <<< grid size ~%" grid-size)
    (setf grid (make-array (list grid-size grid-size) :initial-element nil))
      
    ;;sample char2int
    (loop for x from (char-code #\a) to (char-code #\s) do
	 (format t "~s ~s ~s    " x (- x 97) (code-char x)))
					;get char from str
    (format t "~% :~s:   ~%"  (char "abc" 1))
    
    (add-handicaps grid)
    (print-board grid)

    ))

;;;==================================================
(in-package :cl-user)
(sgf-analyser:main)
