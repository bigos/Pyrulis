(in-package :web-app-trial)

(defun home-page ()
  (home-page-view))

(defun faa1 ()
  (faa1-view))

(defun foo1 ()
  ;;(foo1-view)
  (default-layout (foo1-view))
  )

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
      (who:fmt "~A" content)
      (:footer "footer")))))
