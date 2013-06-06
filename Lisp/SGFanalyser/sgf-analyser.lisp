(in-package :sgf-analyser)

(defvar *app-path* "/home/jacek/Programming/Pyrulis/Lisp/SGFanalyser/")
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
(defvar *last-column-letter* (subseq *board-column-letters* (- *board-size* 1)))

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

(defun stone-at (board coordinates)
  (aref board (car coordinates) (cdr coordinates)))

(defun safe-stone-at (board coordinates)
  (if (or (invalid-coordinate-p (car coordinates)) 
	  (invalid-coordinate-p (cdr coordinates)))
      :out
      (stone-at board coordinates)))

(defun board-edge-p (coordinate)
  (or (eq coordinate 0)
      (eq coordinate (1- *board-size*))))

(defun invalid-coordinate-p (coordinate)
  (or (< coordinate 0)
      (> coordinate (1- *board-size*))))

(defun neighbours (board coordinates)
  (format t "~&will try to find neighbours for ~s     edges ~s:~s   ~%" 
	  coordinates (board-edge-p (car coordinates)) (board-edge-p (cdr coordinates)))
  (let ((lives) (whites) (blacks))
    (format T "~s" `( ;;above
		     ,(safe-stone-at board (cons (car coordinates)  (1- (cdr coordinates))))     
		      ;;right
		     ,(safe-stone-at board (cons (1+ (car coordinates)) (cdr coordinates)))
		      ;;bottom
		     ,(safe-stone-at board (cons (car coordinates) (1+ (cdr coordinates))))
		      ;;left
		     ,(safe-stone-at board (cons (1- (car coordinates)) (cdr coordinates)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun run ()        
  (let ((board) (coordinates))
    (format T "~%~%~A <<<<<<<<<<~%" *game-record*)   
    (game-stats )
    (format t "~%~d <<< board size ~%" *board-size*)
    (setf board (make-array `(,*board-size* ,*board-size*) :initial-element nil))
      
    ;; just testing some lisp functions ;;;;;;;;;;;;;;;;;
    ;;sample char2int
    (loop for x from (char-code #\a) to (char-code #\s) do
	 (format t "~s ~s ~s    " x (- x 97) (code-char x)))
    ;;get char from str
    (format t "~% :~s:   ~%"  (char "abc" 1))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    (add-handicaps board)
    (print-board board)
    (dolist (move (subseq (cdr *game-record*) 0 20))
      (format t "color ~S coordinates ~S~%" (caar move) (sgf-to-i (cdar move)))
      (place-stone board (caar move) (sgf-to-i (cdar move))))
    (print-board board)
     
    (setq coordinates (enter-coordinates))    
    (format t "the coordinates are: ~A~%"  coordinates)

    (format t "~A"  (stone-at board coordinates))
    (neighbours board coordinates)
    ))

;;;==================================================
(format t "~&Type (sgf-analyser:run) to start the program")
