
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun create-structures (file-path)
  (let ((structures) (s) (x) (y))
    (with-open-file (stream file-path)
      (do ((line (read-line stream nil)
		 (read-line stream nil))) 
	  ((null line))
	(setq line (string-trim " " line))
	(format t "~A~%" line)
	(if (not (search "-" line :start1 0 :end1 1 ))
	    (progn
	      (unless (string= line "")
		(progn 
		  (setq x (string-trim " " (subseq line 0 (position " " line :test #'string=))))
		  (setq y (string-trim " " (subseq line (+ 1 (position ">" line :test #'string=)))))
		  (setq s (concatenate 'list  s (list (list x (if (equal y "") nil y))))))))
	    (progn	      
	      (setq structures (concatenate 'list structures   (list s)))
	      (setq s nil)))))
    (setq structures (concatenate 'list structures (list s)))))

(defun swap (i1 i2 lst)
  (format t "~a ~a ~a~%" lst i1 i2)
  (let* ((a1 (nth i1 lst)) (a2 (nth i2 lst)))
    (format t " ~s ~s~%~a ~a ~a~%" a1 a2 lst i1 i2)
    (replace lst (list a2) :start1 i1)
    (replace lst (list a1) :start1 i2)))

(let ((jobs) (job-priorities))
  (defun job-collection (structures)
    (dolist ( job-pair structures)
      (setq jobs (concatenate 'list jobs (list (string (car job-pair)))))
      (if (cadr job-pair)
          (setq job-priorities
                (concatenate 'list
                             job-priorities
                             (list (list (cadr job-pair) (car job-pair))))))))

  (defun job-priorities-returner ()
    (car (list job-priorities)))

  (defun jobs-returner ()
    (car (list jobs)))

  (defun ordered-jobs ()
    (let ((cind) (pind))
      (dolist (jp job-priorities)
        (format t "^ ~S~%" jp)
        (setq cind (position  (car jp)  jobs :test #'string=))
        (setq pind (position  (cadr jp) jobs :test #'string=))
        (format t "~S ! ~S + ~S ~S~%" cind pind (car jp) (cadr jp))
        (format t "c ~A p ~A~%" cind pind))
      (if (and cind pind)
	  (swap cind pind jobs))))
        

  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun main ()
  (let* ((file-path "/home/jacek/Programming/PuzzleTest/data.txt") (structures))
    (format nil "~S~%" (load-file file-path))
    (setq structures (create-structures file-path))
    (format T "~%############################## ~S ~%" structures )
    (job-collection (nth 3 structures))
    (format T "~S~%" (job-priorities-returner))
    (format T "~S~%" (jobs-returner))
    (format T "ordered jobs: ~S ~%"  (ordered-jobs))
    (format T "~S~%" (jobs-returner))
    ))
