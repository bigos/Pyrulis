;;;; cljs.lisp

(in-package #:cljs)

;; One thing we have to do is make sure that CL-WHO and Parenscript use
;; different string delimiters so that literal strings will work as intended
;; in JavaScript code inlined in HTML element properties.
(setf *js-string-delimiter* #\")

(defparameter *server* (start (make-instance 'easy-acceptor :port 8000)))

(define-easy-handler (tutorial2 :uri "/tutorial2") ()
  (with-html-output-to-string (s)
    (:html
     (:head
      (:title "Parenscript tutorial: 2nd example")
      (:script :type "text/javascript" :src
               "http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js")
      (:script :type "text/javascript"
               :src "/tutorial2.js"))
     (:body
      (:h2 "Parenscript and jQuery test")
      (:p
       (:a :href "#" :onclick (ps (jquery-test)) "Add Content"))
      (:p
       (:a :href "#" :onclick (ps (jquery-clear-results)) "Clear"))
      (:div :id "results")
      ))))

(define-easy-handler (tutorial2-javascript :uri "/tutorial2.js") ()
  (setf (content-type*) "text/javascript")
  (ps
    (defun jquery-test ()
      (chain ($ "#results") (append
                             (who-ps-html (:p "Success")))))
    (defun jquery-clear-results ()
      (chain ($ "#results") (empty)))))
