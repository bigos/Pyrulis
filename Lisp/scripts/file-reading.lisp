;;#! /usr/bin/sbcl --script

(defun load-file-old (path)  
  (with-open-file (stream path)
    (with-output-to-string (s)
      (dotimes (x (file-length stream)) 
	(format s "~c" (read-char stream) x)))))

(defun load-file (path) 
  (with-output-to-string (out)
    (with-open-file (in path)
      (loop with buffer = (make-array 8192 :element-type 'character)
	 for n-characters = (read-sequence buffer in)
	 while (< 0 n-characters)
	 do (write-sequence buffer out :start 0 :end n-characters)))))

(format T "~A" (load-file "./assos1.txt"))
