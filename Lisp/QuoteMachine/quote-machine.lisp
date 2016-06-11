(in-package :quote-machine)

(defvar *application-directory* (asdf:system-source-directory :quote-machine))

(setf css-lite:*indent-css* 4)

;;; Instantiate VHOSTs
(defvar vhost1 (make-instance 'hunchentoot:easy-acceptor :port 5000))

;;; Start and Stop
(defun run ()
  (hunchentoot:start vhost1))

(defun stop ()
  (hunchentoot:stop vhost1))

;;; make parenscript work nicely with cl-who
(setf parenscript:*js-string-delimiter* #\")

;;; helpers --------------------------------------------------------------------
(defmacro escaped-string (string)
  `(who:fmt (who:escape-string (format nil "~A" ,string))))

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

;;; route ----------------------------------------------------------------------
(hunchentoot:define-easy-handler (uri1 :uri "/") ()
  (default-layout (home-page-view)))   ; create default layout with embedded home page

;;; default layout for embedding page views
(defun default-layout (content)

  (who:with-html-output-to-string (out)
    (:html
     (:head
      (:title "Quote machine")
      (:link :href "https://fonts.googleapis.com/css?family=Puritan"
             :type "text/css" :rel "stylesheet")
      (:link :href "https://fonts.googleapis.com/css?family=Passion One"
             :type "text/css" :rel "stylesheet")
      (:link :href "http://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.4.0/css/font-awesome.min.css"
             :type "text/css" :rel "stylesheet")
      (:link :href "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
             :type "text/css" :rel "stylesheet prefetch")
      (:style (str  (css-lite:css
                      (("body") (:background "#ffffc0"))
                      )))
      )
     (:body
      (:h1 "Quote machine")
      (:hr)
      (who:fmt "~A" content)            ;page specific content
      (:footer "built by Jacek")
      (:script :src "https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js")
      (:script :type "text/javascript"
               (str (ps
                      (chain ($ document)
                             (ready
                              (lambda () (chain ($ ".msg")
                                                (text "loaded"))
                                      (return false)
                                      )))

                      )
                    ))))))

(defun home-page-view ()
  (who:with-html-output-to-string (out)
    (:h2  :class "msg" "xyz")
    (:p "This is Home Page" )
    (:a :href "/faa" "More")))
