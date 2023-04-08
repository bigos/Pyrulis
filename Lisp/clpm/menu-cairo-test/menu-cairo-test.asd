(asdf/defsystem:defsystem "menu-cairo-test"
  :depends-on ("alexandria"
               "serapeum"
               "defclass-std"
               "cl-gtk4"
               "cl-gdk4"
               "cl-cairo2"
               ;; "cl-glib"
               )
  :components ((:file "menu-cairo-test")))

;;; trying

;; (clpm-client:clpm-version)
;; (clpm-client:activate-context #p"~/Programming/Pyrulis/Lisp/clpm/menu-cairo-test/clpmfile" :activate-asdf-integration t)
;; (clpm-client:install :context #p"~/Programming/Pyrulis/Lisp/clpm/menu-cairo-test/clpmfile")
;; (asdf:load-system :menu-cairo-test)
