(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(quickproject)))

(setf quickproject:*author* "Jacek Podkanski"
      quickproject:*license* "public domain")

(defparameter *project-name* "")
(defparameter *project-path* nil)

(format t "~&Please enter the project name > ")
(setf *project-name* (read-line)
      *project-path* (format nil "/tmp/Lisp/~A/" *project-name*))

(quickproject:make-project *project-path*
                           :depends-on '(alexandria fiveam))

(format t "~%Thank you~%Your project is at:~%~A~%~A~%"
        *project-path*
        "If you need, you can copy it to permanent location")

;; http://turtleware.eu/posts/Tutorial-Working-with-FiveAM.html
