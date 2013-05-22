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


(hunchentoot:define-easy-handler (home-page :uri "/lo") ()
  (setf (hunchentoot:content-type*) "text/html")
  (format nil (who:with-html-output-to-string (out)
		(:html
		 (:body  
		  (:div
		   (:a :href "/" "see the index")
		   (:span :style "margin:0 2em;" "|")
		   (:a :href "/about_me" "info about me"))
		  (:hr)    
		  (:h1 :id "heading" "Hello Lisp World")
		  (:p :class "message"  "Hi everybody, we have success at last. I've made restas run on Heroku.")
		  (:p (who:fmt "~s  ~a" 1 2))
		  (:footer :style "color: white; text-align: center; background:#444;" "&copy; 2013 Jacek Podkanski")))
		)))

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
(defvar vhost1 (make-instance 'vhost :port 5001))
(defvar vhost2 (make-instance 'vhost :port 5002))

;;; Populate each dispatch table
(push
 (hunchentoot:create-prefix-dispatcher "/foo" 'foo1)
 (dispatch-table vhost1))
(push
 (hunchentoot:create-prefix-dispatcher "/" 'foo3)
 (dispatch-table vhost1))
(push
 (hunchentoot:create-prefix-dispatcher "/foo" 'foo2)
 (dispatch-table vhost2))

;;; Define handlers
(defun foo1 () "Hello")
(defun foo2 () "Goodbye")
(defun foo3 () 
  "<html>
  <head>
<title>this is markup</title>
</head>
<body>
<h1>this is markup</h1>
</body>
</html>")

;;; Start VHOSTs
;(hunchentoot:start vhost1)
;(hunchentoot:start vhost2)

