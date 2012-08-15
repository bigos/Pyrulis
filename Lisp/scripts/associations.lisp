#!/usr/bin/sbcl --script

(defvar *last-class*)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun pluralize (str)
  (let ( (last-letter (subseq str (- (length str) 1 ))))
    (format t "~A    ~S" str last-letter)
    (cond ((equalp last-letter "s")
	   (format nil "~Aes" str))
	  ((equalp last-letter "x")
	   (format nil "~Aes" str))
	  (t (format nil "~As" str)))))

(defun underscorize (str)
  (let ((myword (with-output-to-string (r)
		  (loop for c across str
		     do	 
		       (if (upper-case-p c)
			   (format r "_~C" (char-downcase c))
			   (format r "~C" c))))))
    (string-left-trim "_" myword)))

(defun parse-class (count line)
  (let ((lt-pos (search "<" line))) 
    (format T "~D  ~S~%" count (underscorize (string-trim " " (subseq line 9 lt-pos))))
    ))

(defun parse-assoc (count line)
  (format T "~D  ~S~%" count (string-trim " " line))
  )

(defun process-line (line count)
  (if  (search "ActiveRecord" line)
       (parse-class count line)      
       (parse-assoc count line))) 

(defun main (filename)
  (let ((count 0))
    (with-open-file (stream filename) 
      (do ((line (read-line stream nil)
		 (read-line stream nil)))
	  ((null line))
	(cond ((search "class" line)	       
	       (format T "~%")
	       (setq count (+ 1 count))))
	(process-line line count)))))  


(main "/home/jacek/cl-script/assos1.txt")
