;;;; test-app-weather.lisp

(in-package #:test-app-weather)

;;; "test-app-weather" goes here. Hacks and glory await!

(defvar *application-directory* (asdf:system-source-directory :test-app-weather))

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
                      (("h2") (:margin-bottom "1em"))
                      (("body") (:background "#ffffe0"
                                             :font-family "Open Sans, Sans-serif" ))
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

                     (defun get-location ()
                       (if (@ navigator geolocation)
                           (chain navigator geolocation (get-current-position show-position-weather))
                           (chain console (log "geolocation not supported here"))))

                     (defun show-position-weather (position)
                       (let* ((coords (getprop position 'coords))
                              (lat (getprop position 'coords 'latitude))
                              (lon (getprop position 'coords 'longitude))
                              ;; real data
                              ;; (weather-data (fetch-and-show-json (generate-api-link lat lon)))
                              ;; dummy data
                              (weather-data (example-response))
                              (wether-details ""))
                         ;; (chain console (log position))
                         ;; (chain console (log coords))
                         ;; (chain console (log lat ))
                         ;; (chain console (log lon))
                         (chain console (log weather-data))
                         (chain ($ "h1") (text (+ "Weather in " (getprop weather-data 'name))))
                         (chain ($ ".weather-data")
                                (text
                                 (concatenate 'string
                                              (+ "Weather in " (getprop weather-data 'name) "  ")
                                              (+ "humidity " (getprop weather-data 'main 'humidity) "  ")
                                              (+ "pressure " (getprop weather-data 'main 'pressure) "  ")
                                              (+ "temp " (getprop weather-data 'main 'temp) "  ")
                                              (+ "weather " (getprop weather-data 'weather 0 'description) "  ")
                                              )))

                         ))

                     (defun generate-api-link (lat lon )
                       (+ "http://api.openweathermap.org/data/2.5/weather?APPID=493ec6b326a457dd9e2abc23eb587ac6"
                          "&lat="
                          lat
                          "&lon="
                          lon ))

                     (defun example-response ()
                       "we do not need to keep asking the api for the weather data"
                       (chain *json* (parse
                                      "{\"coord\":{\"lon\":-2.29,\"lat\":53.49},\"weather\":[{\"id\":500,\"main\":\"Rain\",\"description\":\"light rain\",\"icon\"
                       :\"10n\"}],\"base\":\"stations\",\"main\":{\"temp\":286.33,\"pressure\":1006,\"humidity\":98,\"temp_min\":285.37,\"temp_max\"
                       :287.45},\"wind\":{\"speed\":1.81,\"deg\":241.004},\"rain\":{\"3h\":0.96},\"clouds\":{\"all\":92},\"dt\":1465702384,\"sys\"
                       :{\"type\":3,\"id\":28022,\"message\":0.034,\"country\":\"GB\",\"sunrise\":1465702809,\"sunset\":1465763907},\"id\":2638671
                       ,\"name\":\"Salford\",\"cod\":200}"))
                       )

                     (defun show-data (json)
                       ;; data will be shown here
                       (chain console (log "json data --------------------"))
                       (chain console (log json))
                       )

                     (defun fetch-and-show-json (source)
                       (chain $ (when
                                    (chain $ (|getJSON| source))
                                  ) (done (lambda (json)
                                            (show-data json)))))

                     (chain ($ document)
                            (ready (lambda ()
                                     (chain ($ "#get-weather")
                                            (on "click"
                                                (lambda ()
                                                  (get-location)
                                                  undefined)))
                                     undefined) ; overrides parenscipt returns
                                   ))))))))

(defun home-page-view ()
  (who:with-html-output-to-string (out)
    (:h1  :class "text-center" "Weather")
    (:div :class "weather-data" )
    (:div :class "row text-center"
          (:button :id "get-weather" :class "btn btn-primary" "Get Weather"))))
