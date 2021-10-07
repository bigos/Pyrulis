;; https://docs.gtk.org/gtk3/
;;; https://github.com/andy128k/cl-gobject-introspection

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(:alexandria :serapeum :cffi :cl-gobject-introspection :cl-cairo2 :s-xml )))

(defpackage #:window-gir-app
  (:use #:cl
        ;#:ns-0
        ))


;; (load "~/Programming/Pyrulis/Lisp/window-gir-app.lisp")

(in-package :window-gir-app)

(defvar *gtk* (gir:require-namespace "Gtk"))

(defun path-gir-gtk ()
  #p"/usr/share/gir-1.0/Gtk-3.0.gir")

;; (gir-gtk  (last (s-xml:parse-xml-file (path-gir-gtk))) (list 0 1587 9 3))
(defun gir-gtk (lst indexes)
  (cond ((atom lst)
         (list 'last-atom
               lst))
        ((and
          (atom indexes)
          (consp lst))
         (list 'last-index lst))
        ((and
          (equalp indexes '(?))
          (consp lst))
         (list 'zzz
               (loop for x in lst
                     for n = 0 then (1+ n)
                     collect
                     (list 'xxxx n
                           (if (atom x)
                               x
                               (if (atom (car x))
                                   (car x)
                                   (caar x)))))))
        (t
         (let ((lv (nth (car indexes) lst)))
           (if lv
               (gir-gtk (nth (car indexes)  lst) (cdr indexes))
               (list 'index-not-found indexes))))))

;; (nth 1587 (parsed-gir-gtk))
(defun parsed-gir-gtk ()
  (car
   (last
    (s-xml:parse-xml-file (path-gir-gtk)))))

(defun parsed-gir-summary ()
  (loop for l in  (parsed-gir-gtk) collect  (car l)))

(defun parsed-kind-names ()
  (remove-duplicates (loop for el in (cdr  (parsed-gir-summary))
                           collect (car el))
                     :test #'equalp))

(defun parsed-by-nth (ntk-list))

(defun parsed-kind-index ()
  (loop
    for n = 0 then (1+ n)
    for el in (cdr  (parsed-gir-summary))
    collect (list n (subseq el 0 3))))

(defun parsed-kind-name-search (str)
  (loop for l in (parsed-gir-gtk)
        when (and
              (equalp (nth 2 l) 'name)
              (position str
                            (nth 3 l)
                            :test #'equalp))
          collect l))

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
