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
(defvar vhost2 (make-instance 'vhost :port 5002))

;;; Populate each dispatch table
(push
 (hunchentoot:create-prefix-dispatcher "/foo" 'foo1)
 (dispatch-table vhost1))
(push
 (hunchentoot:create-prefix-dispatcher "/faa" 'foo3)
 (dispatch-table vhost1))
(push
 (hunchentoot:create-prefix-dispatcher "/foo" 'foo2)
 (dispatch-table vhost2))

;;; Define handlers
(defun foo1 () "Hello")
(defun foo2 () "Goodbye")
(defun foo3 () 
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

;;; Start VHOSTs
(defun run ()
  (hunchentoot:start vhost1)
  (hunchentoot:start vhost2))

(defun stop ()
  (hunchentoot:stop vhost1)
  (hunchentoot:stop vhost2))
