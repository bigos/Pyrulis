(in-package :web-app-trial)

(defun home-page-view ()
  (who:with-html-output-to-string (out)
    (:html
     (:head
      (:title "Welcome to my humble home page")
      (:link :href "/style.css" :media "all" :rel "stylesheet" :type "text/css"))
     (:body
      (:h1 "Welcome")
      (:p "This is Home Page" )
      (:a :href "/faa" "More")))))


(defun faa1-view ()
  (who:with-html-output-to-string (out)
    (:html
     (:head
      (:title "yet another Lisp web app")
      (:link :href "/style.css" :media "all" :rel "stylesheet" :type "text/css"))
     (:body
      (:div
       (:a :href "/" "see the index")
       (:span :style "margin:0 2em;" "|")
       (:a :href "/about_me?name=Jacek&language=Lisp" "info about me")
       (:span :style "margin:0 2em;" "|")
       (:a :href "/hunchentoot-doc.html" "Documentation"))
      (:hr)
      (:h1 :id "heading" "Hello Lispers")
      (:p :class "message"  "Hi everybody, we have lift off.")
      (:p "acceptor object" (escaped-string  hunchentoot:*acceptor*))
      (:footer (who:fmt "&copy; ~a Jacek Podkanski" (+ 2000 14)))))))

(defun foo1-view ()
  (who:with-html-output-to-string (out)
    (:html
     (:head
      (:title "This is foo")
      (:link :href "/style.css" :media "all" :rel "stylesheet" :type "text/css")
      (:script :src "jquery-2.1.1.min.js")
      (:script :src "/javascript.js" ))
     (:body
      (:h1 "Foo")
      (:a :href "/faa" "faa")
      (:p :class "my-info" "foo foo foo"
          (escaped-string " <tag>text</tag> y ")
          (escaped-string hunchentoot:*request*)
          (who:fmt "~s" (hunchentoot:get-parameters*)))
      (:p
       (who:fmt "~a"  (pp-object hunchentoot:*request*)))
      (hunchentoot:log-message* :info "abcdef ~D~%~%~A~%" 123 (inspect-object hunchentoot:*reply*))
      (:a :href "#" :onclick (parenscript:ps (greeting-callback)) "click me")
      (:h3 "jQuery test")
      (:p
       (:a :href "#"
           :onclick (parenscript:ps (hiding-callback))
           "click to trick"))
      ))))
