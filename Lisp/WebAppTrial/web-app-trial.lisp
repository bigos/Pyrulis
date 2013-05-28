(in-package :web-app-trial)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(format t "~&Type (in-package :web-app-trial) and then (run) to start the program, 
then visit: localhost:5001/ and localhost:5002/")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Subclass ACCEPTOR
(defclass vhost (hunchentoot:easy-acceptor)
  ;; slots
  ((dispatch-table
    :initform '()
    :accessor dispatch-table
    :documentation "List of dispatch functions"))
  ;; options
  (:default-initargs		       ; default-initargs must be used
   :address "127.0.0.1"))	       ; because ACCEPTOR uses it


;;; Instantiate VHOSTs
(defvar vhost1 (make-instance 'vhost :port 5001))

;;; Start and Stop
(defun run ()
  (hunchentoot:start vhost1))

(defun stop ()
  (hunchentoot:stop vhost1))


;;; Routes
(hunchentoot:define-easy-handler (uri1 :uri "/faa") ()
  (setf (hunchentoot:content-type*) "text/html")
  (faa1))

(hunchentoot:define-easy-handler (uri2 :uri "/about_me") ()
  (setf (hunchentoot:content-type*) "text/html")
  (foo1))


;;; Views
(defun faa1 () 
  (who:with-html-output-to-string (out)
    (:html
     (:head
      (:title "yet another Lisp web app")
      (:style :type "text/css" "h1{color:red;}~%p.message{color:blue;}"))
     (:body  
      (:div
       (:a :href "/" "see the index")
       (:span :style "margin:0 2em;" "|")
       (:a :href "/about_me" "info about me")
       (:span :style "margin:0 2em;" "|")
       (:a :href "/hunchentoot-doc.html" "Documentation"))
      (:hr)    
      (:h1 :id "heading" "Hello Lispers")
      (:p :class "message"  "Hi everybody, we have lift off.")
      (:p (who:fmt " acceptor object ~s  " (who:escape-string (format nil "~A"  hunchentoot:*acceptor*))))
      (:footer :style "color: white; text-align: center; background:#444;" "&copy; 2013 Jacek Podkanski")))))

(defun foo1 ()
  (who:with-html-output-to-string (out)
    (:html
     (:head
      (:title "This is foo")) 
     (:body
      (:h1 "Foo")
      (:a :href "/faa" "faa")
      (:p "foo foo foo")
      ))))
