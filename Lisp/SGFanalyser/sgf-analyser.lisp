;;;#! /usr/bin/sbcl --script

(defvar *data-filename*  "/home/jacek/Desktop/jacekpod-coalburner.sgf" )
;;; (defvar *data-filename*  "/home/jacek/Desktop/jacekpod-kgsboy.sgf"   )

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
	"US" "WR" "WT" "BL" "OB" "OW" "WL" "FG" "PM" "VW"))

(defun find-key-position (buffer pos )
  (let ((bracket) (key-position))  
    (setf bracket (position #\[ buffer :start pos))
    (dolist (el (keys-list))
      (setf key (search el buffer :start2 pos :end2 bracket))
      (if key (setf key-position key)))    
    key-position))

(defun get-event-list (buffer)
  (let ((event-start) (event-end 0) (event) (all-events)
	(key-pos) )    
    (loop while event-end do 			
	 (setf event-start (position #\; buffer :start event-end) )
	 (setf event-end (position #\; buffer :start (+ event-start 1)))
	 (setf key-pos (find-key-position buffer event-start))
	 (format t "~%i'm here   ~A~%" (subseq buffer event-start event-end))
	 (if key-pos
	     (format t "~A <<<<<<<<<~%" 
		     (subseq buffer key-pos 
			     (position #\[ buffer :start key-pos)))))
    all-events))


(defun main ()
  (let* ((buffer (read-file-to-string *data-filename*)) (all-events (get-event-list buffer)) )	
    (loop as x from 0 to 5  do
	 (format t "~A~%" (nth x all-events)))			       
    ;(format T "~%~%~S <<<<<<<<<<~%" all-events)
    ))

(main)

