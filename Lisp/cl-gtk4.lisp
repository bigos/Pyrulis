(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(cl-gtk4) ))

(defpackage cl-gtk4
  (:use #:cl #:gtk4))

;; (load "~/Programming/Pyrulis/Lisp/cl-gtk4.lisp")
(in-package #:cl-gtk4)

(defun simple ()
  (let ((app (make-application :application-id "org.bohonghuang.cl-gtk4-example"
                               :flags gio:+application-flags-flags-none+)))
    (connect app "activate"
             (lambda (app)
               (let ((window (make-application-window :application app)))
                 (setf (window-title window)
                       "Simple Counter"
                       (window-default-size window)
                       (list 400 400))

                 (let ((box (make-box :orientation +orientation-vertical+
                                      :spacing 4)))
                   (let ((label (make-label :str "0")))
                     (setf (widget-hexpand-p label)
                           t
                           (widget-vexpand-p label)
                           t)
                     (box-append box label)
                     (let ((button-add (make-button :label "Add"))
                           (button-dec (make-button :label "Dec"))
                           (count 0))
                       (connect button-add "clicked" (lambda (button)
                                                       (declare (ignore button))
                                                       (setf (label-text label)
                                                             (format nil "~A" (incf count)))))

                       (connect button-dec "clicked" (lambda (button)
                                                       (declare (ignore button))
                                                       (format t "~&decreasing ====~%")
                                                       (setf (label-text label)
                                                             (format nil "~A" (decf count)))))
                       (box-append box button-add)
                       (box-append box button-dec))
                     (let ((button (make-button :label "Exit")))
                       (connect button "clicked" (lambda (button)
                                                   (declare (ignore button))
                                                   (window-destroy window)))
                       (box-append box button)))
                   (setf (window-child window)
                         box))
                 (window-present window))))
    (gio:application-run app nil)))
