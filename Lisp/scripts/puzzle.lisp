
(defun read-lines (file-path)
  (let ((structures))
    (with-open-file (stream file-path)
      (do ((line (read-line stream nil)
		 (read-line stream nil)))
	  ((null line))
	(setq structures (concatenate 'list structures (list line)))))
    (car (list  structures))))

(defun load-file (path) 
  (with-output-to-string (out)
    (with-open-file (in path)
      (loop with buffer = (make-array 8192 :element-type 'character)
	 for n-characters = (read-sequence buffer in)
	 while (< 0 n-characters)
	 do (write-sequence buffer out :start 0 :end n-characters))) ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun create-structures (file-path) 
  (let ((structures) (s) (x) (y) )     
    (with-open-file (stream file-path)
      (do ((line (read-line stream nil)
		 (read-line stream nil)))
	  ((null line))
	(setq line (string-trim " " line))
	(unless  (search "-" line :start1 0 :end1 1 )
	  (progn (unless (string= line "")
		   (progn (setq x (string-trim " " (subseq line 0 (search " " line))))
			  (setq y (string-trim " " (subseq line (+ 1 (search ">" line)))))))
		 (setq s (concatenate 'list s (list (list x (if (equal y "") nil y))))))
	  (progn (setq structures (concatenate 'list structures s))
		 (setq s nil)))))
    (car (list structures))))

(let ((jobs) (job-priorities))
  (defun job-collection (str)     
    (format t ">>> ~A~%" str)
    (dolist ( job-pair str)             
      (setq jobs (concatenate 'list jobs (car job-pair)))
      (if (cadr job-pair) 
	  (setq job-priorities (concatenate 'list 
					    job-priorities 
					    (list (list (cadr job-pair) (car job-pair))))))))

  (defun job-priorities-returner ()
    (car (list job-priorities)))

  (defun jobs-returner () 
    (car (list jobs))) )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
(defun main ()
  (let* ((file-path "/home/jacek/Programming/PuzzleTest/data.txt") (structures))
    (format nil "~S~%" (load-file file-path))
    (setq structures (create-structures file-path))    
    (format T "~%############################## ~S ~%" structures )
    (job-collection (subseq structures 5 8))
    (format T "~A~%" (job-priorities-returner))     
    (format T "~A~%" (jobs-returner))
    ))


