
(in-package :board-coordinates)

(defvar *board-column-letters* "abcdefghjklmnopqrst")
(defvar *last-column-letter* (subseq *board-column-letters* (- sgf-analyser::*board-size* 1)))

(defun parse-board-coordinates (str)
  (let* ((column (position (char str 0 ) (subseq *board-column-letters* 0 sgf-analyser::*board-size*) :test #'equal)) 
	 (row (- sgf-analyser::*board-size* (parse-integer (subseq str 1)))))
    (cons column row)))

(defun max-coordinate ()
  (if (> sgf-analyser::*board-size* 19)
      (error "too big board size"))
  (format nil "~a~a" *last-column-letter* sgf-analyser::*board-size*))	

(defun valid-coordinates-p (parsed)
  (and (car parsed) (cdr parsed)))

(defun messages-on-errors (parsed)
  ;;messages for invalid column
  (unless (car parsed)
    (format t "~&wrong column entered, you need a - ~A , except i" *last-column-letter*))
  ;;messages for invalid row
  (if (or (> (cdr parsed) (- sgf-analyser::*board-size* 1)) ;checks for correct row, max 18 in case of 19 size boad
	  (< (cdr parsed) 0))
      (progn
	(format t "~&wrong row entered, you need something between 1 and ~A"  sgf-analyser::*board-size*)
	;; make it fail the validation test
	(setf (cdr parsed) nil))))

(defun enter ()
  (let ((parsed))
    (loop until (valid-coordinates-p parsed) 
       do 
	 (format t "~%~%Enter coordinates (a1 - ~A) " (max-coordinate))	 
	 (handler-case
	     (progn
	       (setq parsed (parse-board-coordinates (read-line)))
	       (messages-on-errors parsed))
	   (condition (err) (format t "couldn't parse the coordinates, enter a1 to ~a ~&raised:  ~S~&~A" (max-coordinate) err err))))
    parsed))
