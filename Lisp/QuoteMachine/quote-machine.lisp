(in-package :quote-machine)

(defvar *application-directory* (asdf:system-source-directory :quote-machine))

;;; make parenscript work nicely with cl-who
(setf parenscript:*js-string-delimiter* #\")

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

(push                                   ; route for static json file
 (hunchentoot:create-static-file-dispatcher-and-handler
  "/quotes.json" (merge-pathnames *application-directory* "quotes.json"))
 hunchentoot:*dispatch-table*)

;;; ----------------------------------------------------------------------------
;;; default layout for embedding page views
(defun default-layout (content)

  (who:with-html-output-to-string (out nil :indent T)
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
                      (("body") (:background "#ffffe0"))
                      )))
      )
     (:body
      (:h1 :class "text-center" "Quote machine")
      (:hr)
      (who:fmt "~A" content)            ;page specific content
      (:footer "built by Jacek")
      (:script :src "https://code.jquery.com/jquery-3.0.0.min.js")


      (:script :type "text/javascript"
               (str (ps
                      (defun random-below (max)
                        "random number from  0 to max-1"
                         (chain |Math| (floor
                                          (* (chain |Math| (random))
                                             max))))

                      (defun show-data (data)
                        (+  (chain console (log (chain |Object| (keys (chain data quotes)) length)))
                           (chain *json* ; *all capitals*
                                  (stringify data))))

                      (defun fetch-json (source)
                          (chain $
                           (|getJSON| source ; |mixedCASE|
                                      (lambda (data)
                                        (progn
                                          (chain
                                           ($ "#message")
                                           (html
                                            (show-data data))))))))

                      (chain ($ document)
                             (ready (lambda ()
                                      (chain ($ "#getquote")
                                             (on "click"
                                                 (lambda ()
                                                   (fetch-json "/quotes.json")))))
                                    )))))))))

(defun home-page-view ()
  (who:with-html-output-to-string (out)
    (:h2  :class "msg text-center" "Bible Quotes")
    (:div :class "row text-center"
          (:div :class "col-xs-12 well message" :id "message"))

    (:div :class "row text-center"
          (:div :class "col-xs-12"
                (:button :id "getquote" :class "btn btn-primary"
                         "Get Quote")))))
