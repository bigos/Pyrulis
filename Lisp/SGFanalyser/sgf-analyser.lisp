;;; define application package
(defpackage :sgf-analyser
  (:use :common-lisp ) 
  (:export :main))

(in-package :sgf-analyser)

;;; define game data related global variables
(defvar *app-path* "/home/jacek/Programming/Pyrulis/Lisp/SGFanalyser/")
(defvar *libraries-path*    (concatenate 'string *app-path* "libraries/"))
(defvar *sgf-data-filename* (concatenate 'string *app-path* "game_records/" "jacekpod-coalburner.sgf"))
(defvar *column-letters* '(a b c d e f g h j k l m n o p q r s t)) 

;;; load libraries
(load (concatenate 'string *app-path* "load.lisp"))

;;; other global variables
(defparameter *game-record*  (sgf-importer:get-move-list *sgf-data-filename*))

(defun header-value (key)  
  (let ((kv (assoc key (car *game-record*) :test #'equalp)))
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

(defun place-stone (board colour coordinates)
  (setf (aref board (car coordinates) (cdr coordinates)) colour))

(defun add-handicaps (board)
  (dolist (handis `(("B" ,(header-value "AB")) ("W" ,(header-value "AW"))))
    (dolist (pos (cadr handis))
      (format t "#### going to place ~A at ~A ~A~%" (car handis) pos (sgf-to-i pos))
      (place-stone board (car handis) (sgf-to-i pos)))))
 
(defun print-board (board)
  (let ((size (car (array-dimensions board))) (stone))
    (format t "~%    ")
    (dolist (c *column-letters*)
      (format t "~a " c))
    (dotimes (r size)
      (format T "~&~2d  " (- size r ))	 
      (dotimes (c size)
	(setf stone (aref board c r))
	(format t "~2a"
		(if stone 
		    stone 
		    "."))))
    (format t "~%~%")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun main ()        
  (let ((board) (board-size) (move))
    (format T "~%~%~A <<<<<<<<<<~%" *game-record*)   
    (game-stats )
    (setf board-size (parse-integer (header-value "SZ")))
    (format t "~%~d <<< board size ~%" board-size)
    (setf board (make-array (list board-size board-size) :initial-element nil))
      
    ;;sample char2int
    (loop for x from (char-code #\a) to (char-code #\s) do
	 (format t "~s ~s ~s    " x (- x 97) (code-char x)))
					;get char from str
    (format t "~% :~s:   ~%"  (char "abc" 1))
    
    (add-handicaps board)
    (print-board board)
    (dolist (move (subseq (cdr *game-record*) 0 3))
      (format t "color ~S coordinates ~S~%" (caar move) (sgf-to-i (cdar move)))
      (place-stone board (caar move) (sgf-to-i (cdar move))))
    (print-board board)

    ))

;;;==================================================
(in-package :cl-user)
(sgf-analyser:main)
