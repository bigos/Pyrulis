;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-
(defpackage #:webtrial-asd
  (:use :cl :asdf))

(in-package :webtrial-asd)

(defsystem webtrial
    :name "webtrial"
    :version "0.0.1"
    :maintainer ""
    :author ""
    :licence ""
    :description "webtrial"
    :depends-on (:weblocks)
    :components ((:file "webtrial")
		 (:module conf
		  :components ((:file "stores"))
		  :depends-on ("webtrial"))
		 (:module src
		  :components ((:file "init-session"))
		  :depends-on ("webtrial" conf))))

