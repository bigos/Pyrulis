(in-package :web-app-trial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun run () 
  (format t "will add some code here")
  (hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port 4242)))

;;;==================================================
(format t "~&Type (web-app-trial:run) to start the program")
