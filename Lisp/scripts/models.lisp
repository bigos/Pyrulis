#!/usr/bin/sbcl --script

(defvar *results* '())
(defvar *filenames* 
  (directory  "/home/jacek/Programming/work/vps/app/models/*.rb"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun process-line (file line count)
  (if (search "ActiveRecord" line) (format T "+++ ~A~%" line))
  (if (or (search "belongs_to" line)
	  (search "has_one" line)
	  (search "has_many" line)
	  (search "has_and" line))
      (format T "~A~%" line) 
      (format nil "-------------  ~A~%" line)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun main (filenames)
  (let ((count 0))
    (loop for f in filenames do 	 
	 (setq count (+ 1 count))
	 (with-open-file (stream f )
	   (do ((line (read-line stream nil)
		      (read-line stream nil)))
	       ((null line))
	     (process-line f line count) )   ))))

(main (directory  "/home/jacek/Programming/work/vps/app/models/*.rb"))
