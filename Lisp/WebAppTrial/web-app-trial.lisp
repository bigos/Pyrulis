(in-package :web-app-trial)

(defparameter *my-acceptors* nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun stop ()
  (dolist (acceptor *my-acceptors*)
    (format t "going to stop: ~S~%" acceptor)
    (hunchentoot:stop acceptor)))

(defun poker ()
  (dolist (this-acceptor *my-acceptors*)
    (format t "found: ~S ~S~%" this-acceptor hunchentoot:*dispatch-table*)))

(defun run () 
  (let ((my-acceptor))
    (format t "This will start the server.~%")
    (format t "You can access the documentation at http://localhost:4242/hunchentoot-doc.html~%")
    (setf my-acceptor (make-instance 'hunchentoot:easy-acceptor :port 4242))
    (push (hunchentoot:start my-acceptor) *my-acceptors*)))

(hunchentoot:define-easy-handler (say-hey :uri "/hi") (name)
  (setf (hunchentoot:content-type*) "text/html")
  (format nil "<html><head><title>hi</title></head><body></body><h1>Hi ~a</h1><p>~s ~s ~s ~s</p></html>" name name (hunchentoot:query-string*) (hunchentoot:get-parameters*) (hunchentoot:post-parameters*)))

(hunchentoot:define-easy-handler (home-page :uri "/lo") ()
  (setf (hunchentoot:content-type*) "text/html")
  (format nil "<html><hread></head><body><h1>Home page</h1></body></html>"))

;;;==================================================
(format t "~&Type (in-package :web-app-trial) and then (run) to start the program, 
then visit: http://localhost:4242/hi?name=Jack")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Subclass ACCEPTOR
(defclass vhost (hunchentoot:acceptor)
  ;; slots
  ((dispatch-table
    :initform '()
    :accessor dispatch-table
    :documentation "List of dispatch functions"))
  ;; options
  (:default-initargs		       ; default-initargs must be used
   :address "127.0.0.1"))	       ; because ACCEPTOR uses it

;;; Specialise ACCEPTOR-DISPATCH-REQUEST for VHOSTs
(defmethod hunchentoot:acceptor-dispatch-request ((vhost vhost) request)
  ;; try REQUEST on each dispatcher in turn
  (mapc (lambda (dispatcher)
	  (let ((handler (funcall dispatcher request)))
	    (when handler ; Handler found. FUNCALL it and return result
	      (return-from hunchentoot:acceptor-dispatch-request (funcall handler)))))
	(dispatch-table vhost))
  (call-next-method))

;;; Instantiate VHOSTs
(defvar vhost1 (make-instance 'vhost :port 50001))
(defvar vhost2 (make-instance 'vhost :port 50002))

;;; Populate each dispatch table
(push
 (hunchentoot:create-prefix-dispatcher "/foo" 'foo1)
 (dispatch-table vhost1))
(push
 (hunchentoot:create-prefix-dispatcher "/foo" 'foo2)
 (dispatch-table vhost2))

;;; Define handlers
(defun foo1 () "Hello")
(defun foo2 () "Goodbye")

;;; Start VHOSTs
(hunchentoot:start vhost1)
(hunchentoot:start vhost2)
