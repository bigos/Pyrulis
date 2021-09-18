;; https://docs.gtk.org/gtk3/
;;; https://github.com/andy128k/cl-gobject-introspection

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(:alexandria :serapeum :cffi :cl-gobject-introspection :cl-cairo2 :s-xml :xmls)))

(defpackage #:window-gir-app
  (:use #:cl))

;; (load "/home/jacek/Programming/Pyrulis/Lisp/window-gir-app.lisp")

(in-package :window-gir-app)

(defvar *gtk* (gir:require-namespace "Gtk"))

(defun path-gir-gtk ()
  #p"/usr/share/gir-1.0/Gtk-3.0.gir")

(defun parsed-gir-gtk ()
  (cdr
   (nth 8 (s-xml:parse-xml-file (path-gir-gtk)))))

(defun parsed-kind-names ()
  (remove-duplicates  (loop for el in (parsed-gir-gtk)
                            collect (caar el))
                      :test #'equalp))

;; (parsed-kinds 'ns-0:|bitfield|)
(defun parsed-kinds (symb)
  (loop for el in (parsed-gir-gtk)
        when (equalp symb (caar el)) collect el))

(defun parsed-classes ()
  (loop for el in (parsed-gir-gtk)
        when (equalp 'ns-0:|class| (caar el)) collect (caddr (car el))))

;; usage (gir-find "ApplicationWindow")
(defun gir-find (str)
  (loop
    for el in (parsed-gir-gtk)
    when (search str (caddr (car el)))
      collect el))

(defun activate (w)
  (declare (ignore w))
  (let ((window (gir:invoke (*gtk* "Window" 'new)
                            (gir:nget *gtk* "WindowType" :toplevel))))


    (setf (gir:property window 'title) "This is GIR")
    (gir:invoke (window "set_default_size")
                400 300)

    (gir:connect window :destroy
                 (lambda (win)
                   (declare (ignore win))
                   (format t "~&pressed close widget~%")
                   (gir:invoke (*gtk* 'main-quit))))

    (gir:invoke (window 'show))))

(defun main ()
  (gir:invoke (*gtk* 'init) nil)
  (let ((app (gir:invoke (*gtk* "Application" 'new)
                         "gir.gtk.ecxample"
                         0))) ;; https://docs.adacore.com/gtkada-docs/gtkada_rm/gtkada_rm/docs/glib__application___spec.html#L165C4

    (gir:connect app :activate
                 (lambda (w)
                   (activate w)))

    (break "aaa")

    (let ((status (gir:invoke (app "g_application_run"))))
      (gir::g-object-unref (cffi:make-pointer app))
      status)))
