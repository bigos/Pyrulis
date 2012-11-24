;;;#! /usr/bin/sbcl --script
(defvar *sgf-files-path* "/home/jacek/Programming/Pyrulis/Lisp/SGFanalyser/sgf_files/" )
(defvar *data-filename* (format nil "~A/~A" *sgf-files-path* "jacekpod-buonof.sgf") )

(defun read-file-to-string (filename)
  (let ((file-content))
    (with-open-file (stream filename)
      (setf file-content (make-string (file-length stream)))
      (read-sequence file-content stream ))   
    file-content ;;returning the value
    ))

(defun keys-list ()
  (list "B" "W" "C" "N" "V" 
	"KO" "MN" "AB" "AE" "AW" "PL" "DM" "GB" "GW" "HO" "UC" "BM" 
	"DO" "IT" "TE" "AR" "CR" "DD" "LB" "LN" "MA" "SL" "SQ" "TR" 
	"AP" "CA" "FF" "GM" "ST" "SZ" "AN" "BR" "BT" "CP" "DT" "EV" 
	"GN" "GC" "ON" "OT" "PB" "PC" "PW" "RE" "RO" "RU" "SO" "TM" 
	"US" "WR" "WT" "BL" "OB" "OW" "WL" "FG" "PM" "VW" "HA" "KM"))

(defun opening-bracket (buffer pos)
  (position #\[ buffer :start pos))

(defun closing-bracket (buffer pos)
  (let ((last-ltr) (ltr) (next-ltr))
    (loop while (< pos  (length buffer)) do
	 (setf ltr (char buffer pos))
	 (setf next-ltr (char buffer (1+ pos)))
	 (if (and (eq #\] ltr) (not (eq #\\ last-ltr)) (not (eq #\[ next-ltr)) )
	     (return pos))
	 (setf last-ltr (char buffer  pos))
	 (incf pos))))

(defun find-key-position  (buffer pos)
  (let ((key) (res ))		 
    (dolist (el (keys-list))
      (setf key (search el buffer :start2 pos :end2 (opening-bracket buffer pos)))   
      (if key (progn (setf res key))))
    res))

(defun get-key-value-position (buffer pos) 
  (let* ((key-pos) (opb) (clb) (key) (val))
    (format t "@ ~a < ~a ~A<<<<<  " pos key-pos (subseq buffer pos (+ 0 pos)))
    (setf key-pos (find-key-position buffer pos)) 
    (setf opb (opening-bracket buffer pos))  
    (setf clb (closing-bracket buffer pos)) 
    (setf key (subseq buffer key-pos opb)) 
    (if (equalp key "AB")	
	(setf val (subseq buffer (1+ opb) clb))	  	
	(setf val (subseq buffer (1+ opb) clb)))
    (list  (1+ clb) key val )
    ))

(defun get-event-list (buffer)
  (let ((event-start) (event-end 0) (all-events) (key-pos 0) (result))    
    (loop while (< key-pos (- (length buffer) 3)) do 			
	 (setf event-start (position #\; buffer :start event-end))
	 (setf event-end (position #\; buffer :start (1+ event-start)))
	 (format t "~%i'm here  ~A~%" (subseq buffer event-start event-end))
	 (loop while (< key-pos (- (length buffer) 2))  do
	      (if (closing-bracket buffer key-pos)	    
		  (setf result (get-key-value-position buffer key-pos)))
	      (format t "~S <<<~%" result)
	      (setf key-pos (car result))	      
	      ))
    all-events))


(defun main ()
  (let* ((buffer (read-file-to-string *data-filename*)) (all-events (get-event-list buffer)) )	
    (loop as x from 0 to 5  do
	 (format t "~A~%" (nth x all-events)))			       
    ;(format T "~%~%~S <<<<<<<<<<~%" all-events)
    ))

(main)

