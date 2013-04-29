(in-package :web-app-trial)

(defparameter *acceptors* nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun stop ()
  (dolist (acceptor *acceptors*)
    (format t "going to stop: ~S~%" acceptor)
    (hunchentoot:stop acceptor)))

(defun poker ()
  (dolist (this-acceptor *acceptors*)
    (format t "found: ~S~%" this-acceptor)
    ))

(defun run () 
  (let ((my-acceptor))
    (format t "This will start the server.~%")
    (format t "You can access the documentation at http://localhost:4242/hunchentoot-doc.html~%")
    (setf my-acceptor (make-instance 'hunchentoot:easy-acceptor :port 4242))
    (push (hunchentoot:start my-acceptor) *acceptors*)
   
    ))

;;;==================================================
(format t "~&Type (web-app-trial:run) to start the program")
