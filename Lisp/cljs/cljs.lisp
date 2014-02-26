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
      (:script :type "text/javascript"
               :src "/tutorial2.js"))
     (:body
      (:h2 "Parenscript tutorial: 2nd example")
      (:a :href "#" :onclick (ps (greeting-callback))
          "Hello World")))))

(define-easy-handler (tutorial2-javascript :uri "/tutorial2.js") ()
  (setf (content-type*) "text/javascript")
  (ps
    (defun greeting-callback ()
      (alert "Hi everyone"))
    (defun sum-digits (number)
      (let ((numary (chain number (to-string) (split (regex "(-\\d|\\d)"))))))
      (loop for x in numary
         when (not (= "" x))
         sum (abs (parse-int x))))
    (defun log-me (str)
      (console.log  str))))
