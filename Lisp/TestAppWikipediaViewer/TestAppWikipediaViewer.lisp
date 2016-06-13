;;;; TestAppWikipediaViewer.lisp

(in-package #:testappwikipediaviewer)

;;; "TestAppWikipediaViewer" goes here. Hacks and glory await!

(defvar *application-directory* (asdf:system-source-directory :testappwikipediaviewer))

;;; suspicious - please review
;;; make parenscript work nicely with cl-who
;;(setf parenscript:*js-string-delimiter* #\")

;;; make css indent nicely
(setf css-lite:*indent-css* 4)

;;; cl-who config
(setf cl-who:html-mode :html5)

;;; Instantiate VHOSTs
(defvar vhost1 (make-instance 'hunchentoot:easy-acceptor :port 5000))

;;; Start and Stop
(defun run ()
  (hunchentoot:start vhost1))

(defun stop ()
  (hunchentoot:stop vhost1))

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


;;; ----------------------------------------------------------------------------
;;; default layout for embedding page views
(defun default-layout (content)

  (who:with-html-output-to-string (out nil :indent T)
    (:html
     (:head
      (:title "Weather")
      (:link :href "https://fonts.googleapis.com/css?family=Puritan"
             :type "text/css" :rel "stylesheet")
      (:link :href "https://fonts.googleapis.com/css?family=Open Sans"
             :type "text/css" :rel "stylesheet")
      (:link :href "http://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.4.0/css/font-awesome.min.css"
             :type "text/css" :rel "stylesheet")
      (:link :href "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
             :type "text/css" :rel "stylesheet prefetch")
      (:style (str  (css-lite:css

                      ))))
     )
    (:body
     (who:fmt "~A" content)             ;page specific content
     (:footer :class "text-center" "built by Jacek")
     (:script :src "https://code.jquery.com/jquery-3.0.0.min.js")


     (:script :type "text/javascript"
              (str (ps
                     (defun random-below (max)
                       "random number from  0 to max-1"
                       (chain |Math| (floor (* (chain |Math| (random)) max))))



                     (defun fetch-and-show-json (source)
                       (chain $ (when
                                    (chain $ (|getJSON| source))
                                  ) (done (lambda (json)
                                            (
                                             ;; your code here
                                             json)))))

                     (chain ($ document)
                            (ready (lambda ()
                                     ;; your code here
                                     undefined) ; overrides parenscipt returns
                                   ))))))))




(defun home-page-view ()
  (who:with-html-output-to-string (out)
    (:div )))
