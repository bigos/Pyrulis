;; https://docs.gtk.org/gtk3/
;;; https://github.com/andy128k/cl-gobject-introspection

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(:alexandria :serapeum :cffi :cl-gobject-introspection :cl-cairo2)))

(defpackage #:window-gir-app
  (:use #:cl))

;; (load "/home/jacek/Programming/Pyrulis/Lisp/window-gir-app.lisp")

(in-package :window-gir-app)

(defvar *gtk* (gir:require-namespace "Gtk"))

(defun main ()
  (gir:invoke (*gtk* 'init) nil)
  (let ((app (gir:invoke (*gtk* "Application" 'new)
                         "gir.gtk.ecxample"
                         0))) ;; https://docs.adacore.com/gtkada-docs/gtkada_rm/gtkada_rm/docs/glib__application___spec.html#L165C4
    app))
