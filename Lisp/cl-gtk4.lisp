(cl:in-package "CL-USER")

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(cl-gtk4
                  cl-gdk4
                  cl-cairo2)))

(defpackage #:cairo-gobject
  (:use)
  (:export #:*ns*))

(in-package #:cairo-gobject)

(gir-wrapper:define-gir-namespace "cairo")

(cl:in-package "CL-USER") ; make sure you come back to cl-user because the previous package does not use it

(defpackage #:cl-gtk4-test
  (:use :cl #:gtk4))

;; (load "~/Programming/Pyrulis/Lisp/cl-gtk4.lisp")
(in-package #:cl-gtk4-test)

(defclass model ()
  ((cnt :accessor cnt :initform 0)))

(defparameter *model* (make-instance 'model))

(cffi:defcstruct gdk-rgba
  (red :double)
  (green :double)
  (blue :double)
  (alpha :double))

(defmacro with-gdk-rgba ((pointer color) &body body)
  `(cffi:with-foreign-object (,pointer '(:struct gdk-rgba))
                             (let ((,pointer (make-instance 'gir::struct-instance
                                                            :class (gir:nget gdk::*ns* "RGBA")
                                                            :this ,pointer)))
                               (gdk:rgba-parse ,pointer ,color)
                               ,@body)))

(defun draw-func (area cr width height)
  (format t "draw-func in action ===========================~%")
  (let ((style-context (gtk:widget-style-context area)))
    (cairo:arc (/ (coerce (the (signed-byte 32) width) 'single-float) 2.0)
               (/ (coerce (the (signed-byte 32) height) 'single-float) 2.0)
               (/ (min width height) 2.0) 0.0 (* 2.0 (coerce pi 'single-float)))

    (let ((color (gtk:style-context-color style-context)))
      (gdk:cairo-set-source-rgba cr color)
      (cairo:fill-path))
    (cairo:arc (/ (coerce (the (signed-byte 32) width) 'single-float) 2.0)
               (/ (coerce (the (signed-byte 32) height) 'single-float) 2.0)
               (/ (min width height) 4.0) 0.0 (* 2.0 (coerce pi 'single-float)))
    (with-gdk-rgba (color (cond
                            ((> (cnt *model*) 10)
                             "#2233FFFF")
                            ((>= 10 (cnt *model*) 0)
                             "#FFFFFFFF")
                            ((< (cnt *model*) 0)
                             "#FF2233FF")))
      (gdk:cairo-set-source-rgba cr color)
      (cairo:fill-path))))

(cffi:defcallback %draw-func :void ((area :pointer)
                                    (cr :pointer)
                                    (width :int)
                                    (height :int)
                                    (data :pointer))
                  (declare (ignore data))
                  (let ((cairo:*context* (make-instance 'cairo:context
                                                        :pointer cr
                                                        :width width
                                                        :height height
                                                        :pixel-based-p nil)))
                    (draw-func (make-instance 'gir::object-instance
                                              :class (gir:nget gtk:*ns* "DrawingArea")
                                              :this area)
                               (make-instance 'gir::struct-instance
                                              :class (gir:nget cairo-gobject:*ns* "Context")
                                              :this cr)
                               width height)))

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
                     (let ((canvas (gtk:make-drawing-area))
                           (button-add (make-button :label "Add"))
                           (button-dec (make-button :label "Dec"))
                           (count 0))

                       (setf (drawing-area-content-width canvas) 100
                             (drawing-area-content-height canvas) 100
                             (drawing-area-draw-func canvas) (list (cffi:callback %draw-func)
                                                                   (cffi:null-pointer)
                                                                   (cffi:null-pointer)))

                       (connect button-add "clicked" (lambda (button)
                                                       (declare (ignore button))
                                                       (setf (label-text label) (format nil "~A" (incf count))
                                                             (cnt *model*) count)
                                                       (widget-queue-draw canvas)))

                       (connect button-dec "clicked" (lambda (button)
                                                       (declare (ignore button))
                                                       (format t "~&decreasing ====~%")
                                                       (setf (label-text label) (format nil "~A" (decf count))
                                                             (cnt *model*) count)
                                                       (widget-queue-draw canvas)))
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
