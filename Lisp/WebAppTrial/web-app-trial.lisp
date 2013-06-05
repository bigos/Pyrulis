(in-package :web-app-trial)

(defvar *application-directory* (asdf:system-source-directory :web-app-trial))

;;; Instantiate VHOSTs
(defvar vhost1 (make-instance 'hunchentoot:easy-acceptor :port 5000))

;;; Start and Stop
(defun run ()
  (hunchentoot:start vhost1))

(defun stop ()
  (hunchentoot:stop vhost1))

;;; Routes
(push
 (hunchentoot:create-static-file-dispatcher-and-handler 
  "/style.css" (merge-pathnames *application-directory* "style.css"))
 hunchentoot:*dispatch-table*)

(hunchentoot:define-easy-handler (uri1 :uri "/faa") ()
  (faa1))

(hunchentoot:define-easy-handler (uri2 :uri "/about_me") ()
  (foo1))

(hunchentoot:define-easy-handler (uri3 :uri "/") ()
  (home-page))

(hunchentoot:define-easy-handler (js1 :uri "/javascript.js") ()
  (setf (hunchentoot:content-type*) "text/javascript")
  (app-js))

;;; helpers
(defmacro escaped-string (string)
  `(who:fmt (who:escape-string (format nil "~A" ,string))))

;;; make parenscript work nicely with cl-who
(setf parenscript:*js-string-delimiter* #\")

(defun inspect-object (obj)
  (loop for the-slot in (mapcar #'sb-pcl:slot-definition-name (sb-pcl:class-slots (class-of obj))) 
     collect (list the-slot  (if (slot-boundp obj the-slot)
				 (slot-value obj the-slot)
				 "unbound"))))
;;; pretty print object on a web page
(defun pp-object (obj)
  (with-output-to-string (str) 
    (format str "<pre>")
    (format str "~a" (who:escape-string (format nil "~a~%" obj)))
    (loop for the-slot in (mapcar #'sb-pcl:slot-definition-name (sb-pcl:class-slots (class-of obj))) 
       do
	 (format str "~A~%" (who:escape-string (format nil "~A" (list the-slot  (if (slot-boundp obj the-slot)
										    (slot-value obj the-slot)
										    "unbound"))))))
    (format str "</pre>")))

;;; Views
(defun home-page ()
  (who:with-html-output-to-string (out)
    (:html
     (:head
      (:title "Welcome to my humble home page")
      (:link :href "/style.css" :media "all" :rel "stylesheet" :type "text/css"))
     (:body
      (:h1 "Welcome")
      (:p "This is Home Page" )
      (:a :href "/faa" "More")))))

(defun faa1 () 
  (who:with-html-output-to-string (out)
    (:html
     (:head
      (:title "yet another Lisp web app")
      (:link :href "/style.css" :media "all" :rel "stylesheet" :type "text/css"))
     (:body  
      (:div
       (:a :href "/" "see the index")
       (:span :style "margin:0 2em	;" "|")
       (:a :href "/about_me?name=Jacek&language=Lisp" "info about me")
       (:span :style "margin:0 2em;" "|")
       (:a :href "/hunchentoot-doc.html" "Documentation"))
      (:hr)    
      (:h1 :id "heading" "Hello Lispers")
      (:p :class "message"  "Hi everybody, we have lift off.")
      (:p "acceptor object" (escaped-string  hunchentoot:*acceptor*))
      (:footer "&copy; 2013 Jacek Podkanski")))))

(defun foo1 ()
  (who:with-html-output-to-string (out)
    (:html
     (:head
      (:title "This is foo")
      (:link :href "/style.css" :media "all" :rel "stylesheet" :type "text/css")
      (:script :src "/javascript.js" )) 
     (:body
      (:h1 "Foo")
      (:a :href "/faa" "faa")
      (:p "foo foo foo"
	  (escaped-string " <tag>text</tag> y ")
	  (escaped-string hunchentoot:*request*)
	  (who:fmt "~s" (hunchentoot:get-parameters*)))
      (:p
       (who:fmt "~a"  (pp-object hunchentoot:*request*)))
      (hunchentoot:log-message* :info "abcdef ~D~%~%~A~%" 123 (inspect-object hunchentoot:*request*))
      (:a :href "#" :onclick (parenscript:ps (greeting-callback)) "click me")))))
