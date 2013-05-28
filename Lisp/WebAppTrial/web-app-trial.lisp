(in-package :web-app-trial)

;;; Instantiate VHOSTs
(defvar vhost1 (make-instance 'hunchentoot:easy-acceptor :port 5000))

;;; Start and Stop
(defun run ()
  (hunchentoot:start vhost1))

(defun stop ()
  (hunchentoot:stop vhost1))

;;; Routes
(hunchentoot:define-easy-handler (uri1 :uri "/faa") ()
  (faa1))

(hunchentoot:define-easy-handler (uri2 :uri "/about_me") ()
  (foo1))

(hunchentoot:define-easy-handler (style1 :uri "/style.css") ()
  (setf (hunchentoot:content-type*) "text/css")
  (format nil "~a ~a" 
	  "body{background: #eeffcc; font-family: arial;}" 
	  "footer{color: white; text-align: center; background:#464;}"))

;;; Views
(defun faa1 () 
  (who:with-html-output-to-string (out)
    (:html
     (:head
      (:title "yet another Lisp web app")
      (:link :href "style.css" :media "all" :rel "stylesheet" :type "text/css"))
     (:body  
      (:div
       (:a :href "/" "see the index")
       (:span :style "margin:0 2em;" "|")
       (:a :href "/about_me?name=Jacek&language=Lisp" "info about me")
       (:span :style "margin:0 2em;" "|")
       (:a :href "/hunchentoot-doc.html" "Documentation"))
      (:hr)    
      (:h1 :id "heading" "Hello Lispers")
      (:p :class "message"  "Hi everybody, we have lift off.")
      (:p (who:fmt " acceptor object ~s  " (who:escape-string (format nil "~A"  hunchentoot:*acceptor*))))
      (:footer "&copy; 2013 Jacek Podkanski")))))

(defun foo1 ()
  (who:with-html-output-to-string (out)
    (:html
     (:head
      (:title "This is foo")
      (:link :href "style.css" :media "all" :rel "stylesheet" :type "text/css")) 
     (:body
      (:h1 "Foo")
      (:a :href "/faa" "faa")
      (:p "foo foo foo"
	  (who:fmt (who:escape-string (format nil "~a" hunchentoot:*request*)))
	  (who:fmt "~s" (hunchentoot:get-parameters*)))))))
