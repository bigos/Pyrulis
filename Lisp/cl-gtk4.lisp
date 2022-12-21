(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(cl-gtk4 cl-cairo2)))

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
                     (let ((canvas (make-drawing-area))
                           (button-add (make-button :label "Add"))
                           (button-dec (make-button :label "Dec"))
                           (count 0))

                       ;; One of the major differences between GTK 3 and GTK 4 is
                       ;; that we are now targeting GL / Vulkan instead of cairo.
                       ;; https://blog.gtk.org/2020/04/24/custom-widgets-in-gtk-4-drawing/
                       ;; we do not use draw signal in gtk4
                       ;; (connect canvas "draw" (lambda (widget context)
                       ;;                          ))


                       (setf (gtk4:drawing-area-content-width canvas) 50
                             (gtk4:drawing-area-content-height canvas) 50

                             ;; can't figure out how to do custom drawing
                             (gtk4:drawing-area-draw-func canvas) (list
                                                                   (lambda (widget context)
                                                                     (declare (ignore widget ))
                                                                     (let ((cr context))
                                                                       (unwind-protect
                                                                            (cairo:with-context (cr)
                                                                              (cairo:set-source-rgb 1.0 0.5 0.6)
                                                                              (cairo:paint)
                                                                              (cairo:stroke))
                                                                         (cairo:destroy cr))))
                                                                   nil
                                                                   nil))

                       (connect canvas "realize" (lambda (widget)
                                                   (declare (ignore widget))
                                                   ;; create GDK resources here
                                                   ))

                       (connect canvas "resize" (lambda (widget)
                                                  (declare (ignore widget))))

                       ;; ---------------------------------------------------------------

                       (connect button-add "clicked" (lambda (button)
                                                       (declare (ignore button))
                                                       (setf (label-text label)
                                                             (format nil "~A" (incf count)))))

                       (connect button-dec "clicked" (lambda (button)
                                                       (declare (ignore button))
                                                       (format t "~&decreasing ====~%")
                                                       (setf (label-text label)
                                                             (format nil "~A" (decf count)))))
                       (box-append box canvas)
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
