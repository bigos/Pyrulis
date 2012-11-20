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
	"US" "WR" "WT" "BL" "OB" "OW" "WL" "FG" "PM" "VW" "HA" "KM"))

(defun opening-bracket (buffer pos)
  (position #\[ buffer :start pos))

(defun closing-bracket (buffer pos)
  (let ((last-ltr #\a) (ltr))
    (loop while (< pos (1- (length buffer))) do
	 (setf ltr (char buffer pos))
	 (if (and (eq #\] ltr) (not (eq #\\ last-ltr)))
	     (return pos))
	 (setf last-ltr (char buffer  pos))
	 (incf pos))
    pos
))

(defun find-key-position  (buffer pos)
  (let ((key) (res ))
					;(format t " ^^~a ^^^ " (subseq buffer pos (+ 5 pos)))
    (dolist (el (keys-list))
      (setf key (search el buffer :start2 pos :end2 (opening-bracket buffer pos)))
   
      (if key (progn (setf res key)
		     ;;;(format t "        !!!>>!! ~a ~a " key pos)
		     ))

)
    res
  
    )
  )

(defun get-key-value-position (buffer pos) 
  (let* ((key-pos (find-key-position buffer pos)) 
	 (opb (opening-bracket buffer pos))  
	 (clb (closing-bracket buffer pos)) (key) (val))

    (format t "@ ~a < ~a ~A<<<<<  " pos key-pos (subseq buffer pos (+ 0 pos)))
    (setf key-pos (find-key-position buffer pos)) 
    (format t "here 1  ")
    (setf opb (opening-bracket buffer pos))  
    (format t "here 2  ")
    (setf clb (closing-bracket buffer pos)) 

    (format t ">>> k ~a o ~a cl ~a~%" key-pos opb clb)
    (unless opb (quit))
    (setf key (subseq buffer key-pos opb)) 
  (format t "here 3  ")
    (setf val (subseq buffer (1+ opb) clb))
  (format t "here 4  ")
  (list  (1+ clb) key val )
    ))

(defun get-event-list (buffer)
  (let ((event-start) (event-end 0) (all-events) (key-pos) (result))    
    (loop while event-end do 			
	 (setf event-start (position #\; buffer :start event-end) )
	 (setf event-end (position #\; buffer :start (1+ event-start)))
	 (setf key-pos (find-key-position buffer event-start))
	 (format t "~%i'm here   ~A~%" (subseq buffer event-start event-end))
	 (loop while   (< key-pos (length buffer))  do
	      (if key-pos  	    
		  (setf result (get-key-value-position buffer key-pos)))
	      (format t "~A <<<~%" result)
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

