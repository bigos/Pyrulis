;; https://github.com/andy128k/cl-gobject-introspection
;; https://github.com/andy128k/cl-gobject-introspection/blob/master/examples/flood-game/load.lisp
;; https://github.com/andy128k/cl-gobject-introspection/blob/d0136c8d9ade2560123af1fc55bbf70d2e3db539/examples/flood-game/src/glib-timeout-add.lisp#L18

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(:alexandria :serapeum :cffi :cl-gobject-introspection :cl-cairo2)))

(defpackage #:window-gir
  (:use #:cl))

;; (load "/home/jacek/Programming/Pyrulis/Lisp/window-gir.lisp")
(in-package :window-gir)

(defvar *gtk* (gir:require-namespace "Gtk"))
(defun main ()
  (gir:invoke (*gtk* 'init) nil)
  (let ((window (gir:invoke (*gtk* "Window" 'new)
                            (gir:nget *gtk* "WindowType" :toplevel))))

    ;; https://github.com/andy128k/cl-gobject-introspection/blob/d0136c8d9ade2560123af1fc55bbf70d2e3db539/examples/maze/src/gui/drawing.lisp#L27
    (setf (gir:property window 'title) "This is GIR")
    (gir:invoke (window "set_default_size")
                400 300)

    (gir:connect window :destroy
                 (lambda (win)
                   (declare (ignore win))
                   (format t "~&pressed close widget~%")
                   (gir:invoke (*gtk* 'main-quit))))

    (gir:invoke (window 'show))
    (gir:invoke (*gtk* 'main))))

;;; now call main
;; (main)
