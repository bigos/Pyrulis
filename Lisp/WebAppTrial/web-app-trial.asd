
(defsystem #:web-app-trial
    :serial t
    :version "0.0.1"
    :author "Jacek Podkanski"
    :licence "GPLv3"
    :depends-on (:hunchentoot)
    :components ((:file "packages") 
		 (:file "web-app-trial"))
    :description "trial web application"
    :long-description "attempt to write a web app using common lisp")
