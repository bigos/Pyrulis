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

(defun square-at (x y &optional cr)
  (let ((size 50))
    (cairo:rectangle x y size size)
    (cairo:fill-path)))

(defun square-centered-at (x y size &optional cr)
  (cairo:rectangle (- x (/ size 2))
                   (- y (/ size 2))
                   size size)
  (cairo:fill-path))

(defun draw-func (area cr width height)
  (format t "drawing ~S x ~S~%" width height)
  (let ((w (coerce (the (signed-byte 32) width)  'single-float))
        (h (coerce (the (signed-byte 32) height) 'single-float)))
    (let ((hw (/ w 2))
          (hh (/ h 2)))
      (let ((context (gtk:widget-style-context area)))

        (cairo:arc
         (/ w 2.0)
         (/ h 2.0)
         (/ (min w h) 2.0)
         0.0
         (* 2.0 (coerce pi 'single-float)))

        (with-gdk-rgba (color "#FF8844FF")
          (gdk:cairo-set-source-rgba cr color))
        (cairo:fill-path)

        (cairo:move-to 0.0 0.0)
        (cairo:line-to w h)
        (with-gdk-rgba (color "#227722FF")
          (gdk:cairo-set-source-rgba cr color))
        (cairo:stroke)

        (let* ((size (/ (min w h) 4.5))
               (dist (+ size (* size 0.05))))



          (with-gdk-rgba (color "#777777CC")
            (gdk:cairo-set-source-rgba cr color))
          (square-centered-at hw hh (+ (* size 3) (* size 0.20)) cr)


          (with-gdk-rgba (color "#FFFFFFCC")
            (gdk:cairo-set-source-rgba cr color))
          (square-centered-at (- hw dist) (- hh dist) size cr)
          (square-centered-at (- hw dist) hh size cr)
          (square-centered-at (- hw dist) (+ hh dist) size cr)

          (square-centered-at hw (- hh dist) size cr)
          (square-centered-at hw hh size cr)
          (square-centered-at hw (+ hh dist) size cr)

          (square-centered-at (+ hw dist) (- hh dist) size cr)
          (square-centered-at (+ hw dist) hh size cr)
          (square-centered-at (+ hw dist) (+ hh dist) size cr)

          (with-gdk-rgba (color "#BBBBBBCC")
            (gdk:cairo-set-source-rgba cr color))

          (cairo:rectangle (- hw (* size 2))
                           (- hh (* size 2.3))
                           (* size 4)
                           (* size 0.67))
          (cairo:fill-path)

          (with-gdk-rgba (color "#FFFFBBCC")
            (gdk:cairo-set-source-rgba cr color))

          (cairo:rectangle (- hw (* size 2))
                           (+ hh (* size 1.65))
                           (* size 4)
                           (* size 0.67))
          (cairo:fill-path)

          )



        ))))

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
                           (widget-vexpand-p canvas) T
                           (drawing-area-draw-func canvas) (list (cffi:callback %draw-func)
                                                                 (cffi:null-pointer)
                                                                 (cffi:null-pointer)))
                     (box-append box canvas))
                   (setf (window-child window)
                         box))
                 (window-present window))))
    (gio:application-run app nil)))

;;; T for terminal
(when nil
  (main)
  (sb-ext:quit))
