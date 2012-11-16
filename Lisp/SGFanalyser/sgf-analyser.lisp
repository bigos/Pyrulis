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

(defun get-key-list ()
  (let ((keys-list (list "B" "KO" "MN" "W" "AB" "AE" "AW" "PL" "C" "DM" "GB" "GW" "HO" "N" "UC" "V" "BM" "DO" "IT" "TE" "AR" "CR" "DD" "LB" "LN" "MA" "SL" "SQ" "TR" "AP" "CA" "FF" "GM" "ST" "SZ" "AN" "BR" "BT" "CP" "DT" "EV" "GN" "GC" "ON" "OT" "PB" "PC" "PW" "RE" "RO" "RU" "SO" "TM" "US" "WR" "WT" "BL" "OB" "OW" "WL" "FG" "PM" "VW")))
    keys-list))

(defun find-key (buffer pos keypos)
  (let ((keys (get-key-list )) (bracket) (key) (found-key))  
    (setf bracket (position #\[ buffer :start pos))
    (dolist (el keys)
      (setf key (search el buffer :start2 pos :end2 bracket) )  
      ;;;(if key 	  (format T "args: el ~A pos ~A bracket ~A  key: ~A subs |~A|  ~%" el pos bracket key (subseq buffer pos keypos) ))
      (if key (setf found-key (subseq buffer key bracket)))
      )
    (format t " ======= ~A === " found-key)
    bracket
    ))

(defun get-event-list (buffer)
  (let ((event-start) (event-end 0) (event) (all-events)
	(key-pos) )    
    (loop while event-end do 			
	 (setf event-start (position #\; buffer :start event-end) )
	 (setf event-end (position #\; buffer :start (+ event-start 1)))

	 (setf key-pos (find-key buffer event-start event-end))

	 (format t "~%i'm here   ~A~%" (subseq buffer event-start event-end)))
    all-events))


(defun main ()
  (let* ((buffer (read-file-to-string *data-filename*)) (all-events (get-event-list buffer)) )	
    (loop as x from 0 to 5  do
	 (format t "~A~%" (nth x all-events)))			       
    ;(format T "~%~%~S <<<<<<<<<<~%" all-events)
    ))

(main)

