(in-package :web-app-trial)

(defvar *acc*)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun stop ()
  (hunchentoot:stop *acc*))

(defun run () 
  (let ((some-var))
    (format t "This will start the server.~%")
    (format t "You can access the documentation at http://localhost:4242/hunchentoot-doc.html~%")
    (setq *acc* (hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port 4242)))))

;;;==================================================
(format t "~&Type (web-app-trial:run) to start the program")
