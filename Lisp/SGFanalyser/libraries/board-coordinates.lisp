(in-package :sgf-analyser)

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

(defun messages-on-coordinate-errors (parsed)
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

(defun enter-coordinates ()
  (let ((parsed))
    (loop until (valid-coordinates-p parsed) 
       do 
	 (format t "~%~% Enter coordinates (a1 - ~A) " (max-coordinate))	 
	 (handler-case
	     (progn
	       (setq parsed (parse-board-coordinates (read-line)))
	       (messages-on-coordinate-errors parsed))
	   (condition (err) (format t "couldn't parse the coordinates, enter a1 to ~a ~&raised:  ~S~&~A" (max-coordinate) err err))))
    parsed))
