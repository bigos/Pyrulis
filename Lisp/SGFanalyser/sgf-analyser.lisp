;;; define application package
(defpackage :sgf-analyser
  (:use :common-lisp ) 
  (:export :main))

(in-package :sgf-analyser)

(defvar *app-path* "/home/jacek/Programming/Pyrulis/Lisp/SGFanalyser/")
(defvar *libraries-path* (concatenate 'string *app-path* "libraries/"))
;;; load libraries
(load (concatenate 'string *app-path* "load.lisp"))

;;; other global variables
(defvar *sgf-data-filename* (concatenate 'string *app-path* "game_records/" "jacekpod-coalburner.sgf"))
(defparameter *game-record* (sgf-importer:get-move-list *sgf-data-filename*))
(defvar *board-size* (parse-integer (header-value "SZ")))
(defvar *column-letters* '("a" "b" "c" "d" "e" "f" "g" "h" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t")) 
(defvar *last-column-letter* (car (subseq *column-letters* (- (parse-integer (header-value "SZ")) 1))))

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

(defun parse-board-coordinates (str)
  (let* ((column (position (subseq str 0 1) (subseq *column-letters* 0 *board-size*) :test #'equal)) 
	 (row (- (parse-integer (header-value "SZ")) (parse-integer (subseq str 1)))))
    (cons column row)))

(defun max-coordinate ()
  (if (> *board-size* 19)
      (error "too big board size"))
  (format nil "~a~a" *last-column-letter* *board-size*))

(defun enter-coordinates ()
  (let ((parsed))
    (loop until (and (car parsed) (cdr parsed)) 
       do 
	 (format t "~%~%Enter coordinates (a1 - ~A) " (max-coordinate))	 
	 (handler-case
	     (progn
	       (setq parsed (parse-board-coordinates (read-line)))
	       (unless (car parsed)
		 (format t "~&wrong column entered, you need a - ~A , except i" *last-column-letter*))
	       (if (or (> (cdr parsed) (- *board-size* 1)) ;checks for correct row, max 18 in case of 19 size boad
		       (< (cdr parsed) 0))
		   (progn
		     (format t "~&wrong row entered, you need something between 1 and ~A"  *board-size*)
		     (setf (cdr parsed) nil))))
	   (condition (err) (format t "couldn't parse the coordinates, enter a1 to ~a ~&raised:  ~S~&~A" (max-coordinate) err err))))
    parsed))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun main ()        
  (let ((board) (move) (coordinates))
    (format T "~%~%~A <<<<<<<<<<~%" *game-record*)   
    (game-stats )
    (format t "~%~d <<< board size ~%" *board-size*)
    (setf board (make-array (list *board-size* *board-size*) :initial-element nil))
      
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
     
    (setq coordinates (enter-coordinates))    
    (format t "the coordinates are: ~A~%"  coordinates)
    ))

;;;==================================================
(in-package :cl-user)
(sgf-analyser:main)
