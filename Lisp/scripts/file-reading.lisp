#! /usr/bin/sbcl --script

(defun load-file (path)  
  (with-open-file (stream path)
    (with-output-to-string (s)
      (dotimes (x (file-length stream)) 
	(format s "~c" (read-char stream) x)
	))))

(format T "~A" (load-file "./assos1.txt"))
