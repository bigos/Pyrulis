(in-package :web-app-trial)

(defparameter *acceptors* nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun stop ()
  (dolist (acceptor *acceptors*) 
    (hunchentoot:stop acceptor)))

(defun run () 
  (let ((some-var))
    (format t "This will start the server.~%")
    (format t "You can access the documentation at http://localhost:4242/hunchentoot-doc.html~%")
    (push (hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port 4242)) *acceptors*)))

;;;==================================================
(format t "~&Type (web-app-trial:run) to start the program")
