(in-package :web-app-trial)

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
