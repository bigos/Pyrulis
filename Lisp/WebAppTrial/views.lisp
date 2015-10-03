(in-package :web-app-trial)

(defun default-layout (content)
  (who:with-html-output-to-string (out)
    (:html
     (:head
      (:title "layout")
      (:link :href "/style.css" :media "all" :rel "stylesheet" :type "text/css")
      (:script :src "jquery-2.1.1.min.js")
      (:script :src "/javascript.js" ))
     (:body
      (:h1 "In Layout")

      (:div
       (:a :href "/" "see the index")
       (:span :style "margin:0 2em;" "|")
       (:a :href "/about_me?name=Jacek&language=Lisp" "info about me")
       (:span :style "margin:0 2em;" "|")
       (:a :href "/hunchentoot-doc.html" "Documentation"))
      (:hr))

      (who:fmt "~A" content)
      (:footer "footer"))))

(defun home-page-view ()
  (who:with-html-output-to-string (out)
    (:h1 "Welcome")
    (:p "This is Home Page" )
    (:a :href "/faa" "More")))

(defun faa1-view ()
  (who:with-html-output-to-string (out)
    (:div
    (:h1 :id "heading" "Hello Lispers")
    (:p :class "message"  "Hi everybody, we have lift off.")
    (:p "acceptor object" (escaped-string  hunchentoot:*acceptor*)))))

(defun foo1-view ()
  (who:with-html-output-to-string (out)
    (:h1 "Foo")
    (:a :href "/faa" "faa")

    (:h3 "jQuery test")
    (:p
     (:a :href "#"
         :onclick (parenscript:ps (hiding-callback))
         "click to see the trick"))

    (:p :class "my-info" "foo foo foo"
        (:br)
        (escaped-string "escaped tags <strong>text</strong>")
        (escaped-string hunchentoot:*request*)
        (who:fmt "~s" (hunchentoot:get-parameters*)))
    (:p
     (who:fmt "~a"  (pp-object hunchentoot:*request*)))
    (hunchentoot:log-message* :info "abcdef ~D~%~%~A~%" 123 (inspect-object hunchentoot:*reply*))
    (:a :href "#" :onclick (parenscript:ps (greeting-callback)) "click me")))
