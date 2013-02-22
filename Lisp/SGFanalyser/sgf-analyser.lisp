
(defvar *app-path* "/home/jacek/Programming/Pyrulis/Lisp/SGFanalyser/")

;;; other global variables
(defvar *sgf-data-filename* (concatenate 'string *app-path* "game_records/" "jacekpod-coalburner.sgf"))
(defparameter *game-record* (sgf-importer:get-move-list *sgf-data-filename*))

(defun header-value (key)  
  (let ((kv (assoc key (car *game-record*) :test #'equalp)))
    (if (listp (cdr kv))
	(car (cdr kv))
	(cdr kv))))

(defvar *board-column-letters* "abcdefghjklmnopqrst")
(defvar *sgf-letters* "abcdefghijklmnopqrs")
(defvar *board-size* (parse-integer (header-value "SZ")))

;;;;;;;;;; previously in board coordinates ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar *board-column-letters* "abcdefghjklmnopqrst")

(defvar *last-column-letter* (subseq *board-column-letters* (- *board-size* 1)))

(defun parse-board-coordinates (str)
  (let* ((column (position (char str 0 ) (subseq *board-column-letters* 0 *board-size*) :test #'equal)) 
	 (row (- *board-size* (parse-integer (subseq str 1)))))
    (cons column row)))

(defun max-coordinate ()
  (if (> *board-size* 19)
      (error "too big board size"))
  (format nil "~a~a" *last-column-letter* *board-size*))	

(defun valid-coordinates-p (parsed)
  (and (car parsed) (cdr parsed)))

(defun messages-on-errors (parsed)
  ;;messages for invalid column
  (unless (car parsed)
    (format t "~&wrong column entered, you need a - ~A , except i" *last-column-letter*))
  ;;messages for invalid row
  (if (or (> (cdr parsed) (- *board-size* 1)) ;checks for correct row, max 18 in case of 19 size boad
	  (< (cdr parsed) 0))
      (progn
	(format t "~&wrong row entered, you need something between 1 and ~A"  *board-size*)
	;; make it fail the validation test
	(setf (cdr parsed) nil))))

(defun enter ()
  (let ((parsed))
    (loop until (valid-coordinates-p parsed) 
       do 
	 (format t "~%~% Enter coordinates (a1 - ~A) " (max-coordinate))	 
	 (handler-case
	     (progn
	       (setq parsed (parse-board-coordinates (read-line)))
	       (messages-on-errors parsed))
	   (condition (err) (format t "couldn't parse the coordinates, enter a1 to ~a ~&raised:  ~S~&~A" (max-coordinate) err err))))
    parsed))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun game-stats ()
  (let ((stats `(("white" . "PW") ("white rank" . "WR") ("black" . "PB") ("black rank" . "BR") ("~%board size" . "SZ") 
		 ("rules" . "RU") ("result" . "RE") ("komi" . "KM") ("~%handicap" . "HA")
		 ,(cond  ((not (zerop (length (header-value "AB"))))  '("black handicap list" . "AB")) 
			 ((not (zerop (length (header-value "AW"))))  '("white handicap list" . "AW"))))))
    (dolist (el stats)
      ;; ~? explanation: http://www.lispworks.com/documentation/HyperSpec/Body/22_cgf.htm
      (format t "~@?: ~S   "  (car  el)   (header-value (cdr el))))))

(defun sgf-to-i (coordinates)
  (labels ((coord (i)
	     (position (char coordinates i) *sgf-letters*)))
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
    (dotimes (c (length *board-column-letters*))
      (format t "~a " (char *board-column-letters* c )))
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
  (let ((board) (coordinates))
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
     
    (setq coordinates (enter))    
    (format t "the coordinates are: ~A~%"  coordinates)
    ))

;;;==================================================

