;;;; packages.lisp

;;;  place for package definitions used by this project

(defpackage #:cairo-diagram
  (:use #:gtk #:gdk #:gdk-pixbuf #:gobject
        #:glib #:gio #:pango #:cairo #:cl))
