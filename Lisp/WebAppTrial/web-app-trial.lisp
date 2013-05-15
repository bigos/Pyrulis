(in-package :web-app-trial)

(defparameter *my-acceptors* nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun stop ()
  (dolist (acceptor *my-acceptors*)
    (format t "going to stop: ~S~%" acceptor)
    (hunchentoot:stop acceptor)))

(defun poker ()
  (dolist (this-acceptor *my-acceptors*)
    (format t "found: ~S~%" this-acceptor)))

(defun run () 
  (let ((my-acceptor))
    (format t "This will start the server.~%")
    (format t "You can access the documentation at http://localhost:4242/hunchentoot-doc.html~%")
    (setf my-acceptor (make-instance 'hunchentoot:easy-acceptor :port 4242))
    (push (hunchentoot:start my-acceptor) *my-acceptors*)))

(hunchentoot:define-easy-handler (say-hey :uri "/hi") 
  (setf (hunchentoot:content-type*) "text/html")
  (format nil "<html><head><title>hi</title></head><body></body><h1>Hi ~a</h1><p>~s ~s ~s ~s</p></html>" (hunchentoot:query-string*) (hunchentoot:get-parameters*) (hunchentoot:post-parameters*)))

;;;==================================================
(format t "~&Type (in-package :web-app-trial) and then (run) to start the program, 
then visit: http://localhost:4242/hi?name=Jack")
