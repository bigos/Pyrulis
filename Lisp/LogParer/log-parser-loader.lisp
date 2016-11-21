#! /usr/local/bin/sbcl --script

(defun loader (args)
  (format t "log parser loader~%")
  (format t "args ~A~%" *posix-argv*)
  (format t "load ~A~%" *load-pathname*)
  (format t "path ~A~%~%" (pathname-directory
                           (parse-namestring *load-pathname*)))
  ;; load the main file called log-parser.lisp, which is in the same directory
  (load  (make-pathname
          :directory
          (pathname-directory
           (parse-namestring *load-pathname*))
          :name "log-parser"
          :type "lisp"))
  ;; execute the main function
  (main (cadr args)))

(loader *posix-argv*)
