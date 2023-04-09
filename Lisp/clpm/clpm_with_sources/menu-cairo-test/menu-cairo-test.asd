(asdf/defsystem:defsystem "menu-cairo-test"
  :depends-on ("alexandria"
               "serapeum"
               "defclass-std"
               "cl-gtk4"
               "cl-gdk4"
               "cl-cairo2"
               "cl-glib")
  :components ((:file "menu-cairo-test")))

;;; trying
;; https://www.clpm.dev/docs/bundle.html
;; (clpm-client:clpm-version)
;; (clpm-client:sync :sources '("quicklisp"))
;; (clpm-client:activate-context #p"~/Programming/Lisp/lispy-experiments/clpm/menu-cairo-test/clpmfile" :activate-asdf-integration t)
;; (clpm-client:install :context #p"~/Programming/Lisp/lispy-experiments/clpm/menu-cairo-test/clpmfile")
;; (asdf:load-system :menu-cairo-test)
;; (menu-cairo-test:cairo-test)
