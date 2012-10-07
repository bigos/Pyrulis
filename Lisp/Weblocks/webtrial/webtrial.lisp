
(defpackage #:webtrial
  (:use :cl :weblocks
        :f-underscore :anaphora)
  (:import-from :hunchentoot #:header-in
		#:set-cookie #:set-cookie* #:cookie-in
		#:user-agent #:referer)
  (:documentation
   "A web application based on Weblocks."))

(in-package :webtrial)

(export '(start-webtrial stop-webtrial))

;; A macro that generates a class or this webapp

(defwebapp webtrial
    :prefix "/"
    :description "webtrial: A new application"
    :init-user-session 'webtrial::init-user-session
    :autostart nil                   ;; have to start the app manually
    :ignore-default-dependencies nil ;; accept the defaults
    :debug t
    )

;; Top level start & stop scripts

(defun start-webtrial (&rest args)
  "Starts the application by calling 'start-weblocks' with appropriate
arguments."
  (apply #'start-weblocks args)
  (start-webapp 'webtrial))

(defun stop-webtrial ()
  "Stops the application by calling 'stop-weblocks'."
  (stop-webapp 'webtrial)
  (stop-weblocks))

