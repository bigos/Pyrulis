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

(defun get-event-list (buffer)
  (let ((event-start) (event-end 0) (event) (all-events))
    (loop while event-end do 			
	 (setf event-start (position #\; buffer :start event-end))
	 (setf event-end (position #\; buffer :start (+ event-start 1)))
	 (setf event (subseq buffer event-start event-end ))
	 (setf all-events  (append all-events (list event))))
    all-events))
(defun get-kv-list (buffer)
  (let ((keys-list (list "B" "KO" "MN" "W" "AB" "AE" "AW" "PL" "C" "DM" "GB" "GW" "HO" "N" "UC" "V" "BM" "DO" "IT" "TE" "AR" "CR" "DD" "LB" "LN" "MA" "SL" "SQ" "TR" "AP" "CA" "FF" "GM" "ST" "SZ" "AN" "BR" "BT" "CP" "DT" "EV" "GN" "GC" "ON" "OT" "PB" "PC" "PW" "RE" "RO" "RU" "SO" "TM" "US" "WR" "WT" "BL" "OB" "OW" "WL" "FG" "PM" "VW")))

))

(defun main ()
  (let* ((buffer (read-file-to-string *data-filename*)) (all-events (get-event-list buffer)) (all-kv (get-kv-list buffer)))	
    (loop as x from 0 to 5  do
	 (format t "~A~%" (nth x all-events)))			       
    ))

(main)

