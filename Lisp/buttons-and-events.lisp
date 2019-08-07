(declaim (optimize (debug 3) (speed 0) (safety 3)))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload :cl-cffi-gtk))

(defpackage :gtk-new3
  (:use :gtk :gobject :glib :pango :cairo :cffi :iterate :cl))

(in-package :gtk-new3)

(defun on-b1-click (b1)
  (format t "hmm ~A~%" b1))

(defun on-b2-click (b2)
  (format t "Aha! ~A~%" b2))

(defun build-ui (window)
  (let* ((vbox (gtk-vbox-new T 10))
         (l1 (gtk-label-new "Hello"))
         (b1 (gtk-button-new-with-label "Press me"))
         (b2 (gtk-button-new-with-label "Press me too")))

    (gtk-container-add window vbox)

    (gtk-box-pack-start vbox l1)

    (gtk-box-pack-start vbox b1)
    (g-signal-connect b1 "clicked" (lambda (b1)
                                     (declare (ignorable b1))
                                     (format t "b1 clicked ~A~%" b1)
                                     (gtk-label-set-text l1 "boooo")
                                     (on-b1-click b1)))

    (gtk-box-pack-start vbox b2)
    (g-signal-connect b2 "clicked" (lambda (b2)
                                     (declare (ignorable b2))
                                     (format t "b2 clicked ~A~%" b2)
                                     (gtk-label-set-text l1 "Hello again")
                                     (on-b2-click b2)))

    (g-signal-connect window "size-allocate" (lambda (window allocation)
                                               (declare (ignorable window)
                                                        (ignorable allocation))
                                               (gtk-label-set-text l1 (format nil "window resized ~A x ~A~%"
                                                                              (gdk:gdk-rectangle-width allocation)
                                                                              (gdk:gdk-rectangle-height allocation)))))))

(defun run-ui ()
  (sb-int:with-float-traps-masked (:divide-by-zero)
    (within-main-loop
      (let ((window (make-instance 'gtk-window :title "Third window"
                                               :default-width 300
                                               :default-height 200
                                               :border-width 12
                                               :type :toplevel)))
        (g-signal-connect window "destroy"
                          (lambda (widget)
                            (declare (ignorable widget))
                            (leave-gtk-main)))

        (build-ui window)

        (gtk-widget-show-all window)))))

(defun main ()
  (run-ui))

(main)
