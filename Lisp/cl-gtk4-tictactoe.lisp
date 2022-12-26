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

(defpackage #:cl-gtk4-tictactoe ; ----------------------------------------------
  (:use :cl #:gtk4))

;; (load "~/Programming/Pyrulis/Lisp/cl-gtk4-tictactoe.lisp")
(in-package #:cl-gtk4-tictactoe)

(defclass model ()
  ())

(defparameter *model* (make-instance 'model))

;;; ============================================================================

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

;;; ============================================================================

(defun draw-func (area cr width height)
  (format t "drawing ~S x ~S~%" width height)
  (let ((context (gtk:widget-style-context area)))
    (cairo:arc
     (/ (coerce (the (signed-byte 32)  width) 'single-float) 2.0)
     (/ (coerce (the (signed-byte 32) height) 'single-float) 2.0)
     (/ (min width height) 2.0)
     0.0
     (* 2.0 (coerce pi 'single-float)))
    (with-gdk-rgba (color "#FF8844FF")
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

;;; ============================================================================

(defun main ()
  (let ((app (make-application :application-id "org.bigos.cl-gtk4-tictactoe"
                               :flags gio:+application-flags-flags-none+)))
    (connect app "activate"
             (lambda (app)
               (let ((window (make-application-window :application app)))
                 (setf (window-title        window) "Tic Tac Toe"
                       (window-default-size window) (list 400 400))
                 (let ((box (make-box :orientation +orientation-vertical+
                                      :spacing 0)))
                   (let ((canvas (gtk:make-drawing-area)))
                     (setf (drawing-area-content-width canvas) 200
                           (drawing-area-content-height canvas) 200
                           (drawing-area-draw-func canvas) (list (cffi:callback %draw-func)
                                                                 (cffi:null-pointer)
                                                                 (cffi:null-pointer)))
                     (box-append box canvas))
                   (setf (window-child window)
                         box))
                 (window-present window))))
    (gio:application-run app nil)))
