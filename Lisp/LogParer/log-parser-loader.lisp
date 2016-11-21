#! /usr/local/bin/sbcl --script

(defun loader (args)
  (format t "log parser loader~%")
  (format t "args ~A~%" *posix-argv*)
  (format t "load ~A~%" *load-pathname*)
  (format t "path ~A~%~%" (pathname-directory
                         (parse-namestring *load-pathname*)))
  (load  (make-pathname
          :directory
          (pathname-directory
           (parse-namestring *load-pathname*))
          :name "log-parser"
          :type "lisp"))

  (main (cadr args)))

(loader *posix-argv*)
