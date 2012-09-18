
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

(defun create-structures (file-path) 
  (let ((structures) (s) (x) (y))
    (block my-block
      (with-open-file (stream file-path)
	(do ((line (read-line stream nil)
		   (read-line stream nil)))
	    ((null line))
	  (setq line (string-trim " " line))
	  (unless  (search "-" line :start1 0 :end1 1 )
	    (progn (unless (string= line "")
		     (progn (setq x (subseq line 0 (search " " line)))
			    (setq y (subseq line (+ 1 (search ">" line))))))
		   (setq s (concatenate 'list s (list (list (string-trim " " x) 
							    (string-trim " " y))))))
	    (progn (setq structures (concatenate 'list structures s))
		   (setq s nil)))))
      (return-from my-block structures))))

(defun dump (structures)
  (dolist (str structures)
    (format t "~A~%" str)
    )
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
(defun main ()
  (let* ((file-path "/home/jacek/Programming/PuzzleTest/data.txt") (structures))
    (format T "~S~%" (load-file file-path))
    (setq structures (create-structures file-path))    
    (format T "~%############################## ~S ~%" structures )
    ; (dump structures)
    
    ))


