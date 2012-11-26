;;;#! /usr/bin/sbcl --script
(defvar *sgf-files-path* "/home/jacek/Programming/Pyrulis/Lisp/SGFanalyser/sgf_files" )
(defvar *data-filename* (format nil "~A/~A" *sgf-files-path* "jacekpod-coalburner.sgf"))

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
	"US" "WR" "WT" "BL" "OB" "OW" "WL" "FG" "PM" "VW" "HA" "KM" "TW" "TB"))

(defun opening-bracket (buffer pos)
  (position #\[ buffer :start pos))

(defun closing-bracket (buffer pos)
  (let ((last-ltr) (ltr))    
    (loop while (< pos  (length buffer)) do
	 (setf ltr (char buffer pos))	 
	 (if (and (eq #\] ltr) (not (eq #\\ last-ltr)))
	     (return pos))
	 (setf last-ltr (char buffer  pos))
	 (incf pos))))

(defun last-closing-bracket (buffer pos)
  (let ((clb))    
    (loop while (< pos  (length buffer)) do
	 (setf clb (closing-bracket buffer pos))
	 (unless (eq #\[ (char buffer (1+ clb)))	   
	   (return clb))
	 (setf pos (1+ clb)))))

(defun val-to-list (val)
  (let ((pos 0) (opb) (clb) (res)) 
    (loop while (< pos (length val)) do
	 (setf opb (opening-bracket val pos))
	 (setf clb (closing-bracket val pos))
	 (setf pos (1+ clb))
	 (setf res (append res (list (subseq val (1+ opb) clb)))))
    res))

(defun find-key-position  (buffer pos)
  (let ((key) (res ))		 
    (dolist (el (keys-list))
      (setf key (search el buffer :start2 pos :end2 (opening-bracket buffer pos)))   
      (if key (progn (setf res key))))
    res))

(defun get-key-value-position (buffer pos) 
  (let* ((key-pos) (opb) (clb) (key) (val) (new-move))
    (setf key-pos (find-key-position buffer pos)) 
    (if (eq (char buffer (1- key-pos)) #\;)
	(setf new-move t))
    (setf opb (opening-bracket buffer pos))  
    (setf clb (last-closing-bracket buffer pos)) 
    (setf key (subseq buffer key-pos opb))     
    (setf val (subseq buffer opb (1+ clb)))
    (list  (1+ clb) key val new-move)
    ))

(defun get-event-list (buffer)
  (let ((event-start) (event-end 0) (key-pos 0) (result) (vlst))    
    (loop while (< key-pos (- (length buffer) 3)) do 			
	 (setf event-start (position #\; buffer :start event-end))
	 (setf event-end (position #\; buffer :start (1+ event-start)))
	 (format t "~%i'm here  ~A~%" (subseq buffer event-start event-end))
	 (loop while (< key-pos (- (length buffer) 3))  do	      
	      (if (last-closing-bracket buffer key-pos)	    
		  (setf result (get-key-value-position buffer key-pos)))
	      (setf vlst (val-to-list (caddr result)))
	      ;(format t "~s  " (caddr result))
	      (format t "~S <<< ~S~%" result vlst)
	      (if (car result) 
		  (setf key-pos (car result)))	      
	      ))
    all-events))

(defun main ()
  (let* ((buffer (read-file-to-string *data-filename*)) (all-events (get-event-list buffer)) )	    			       
    ;(format T "~%~%~S <<<<<<<<<<~%" all-events)
    ))

(main)

