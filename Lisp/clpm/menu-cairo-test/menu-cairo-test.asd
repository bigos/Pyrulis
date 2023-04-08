(asdf/defsystem:defsystem "menu-cairo-test"
  :depends-on ("alexandria"
               "serapeum"
               "defclass-std"
               "cl-gtk4"
               "cl-gdk4"
               "cl-cairo2"
               "cl-glib")
  :components ((:file "menu-cairo-test")))
