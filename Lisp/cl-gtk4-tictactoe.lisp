(cl:in-package "CL-USER")

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(cl-gtk4
                  cl-gdk4
                  cl-glib
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
;;; drawing ====================================================================

(defun square-at (x y)
  (let ((size 50))
    (cairo:rectangle x y size size)
    (cairo:fill-path)))

(defun square-centered-at (x y size)
  (cairo:rectangle (- x (/ size 2))
                   (- y (/ size 2))
                   size size)
  (cairo:fill-path))

(defun draw-func (area cr width height)
  (declare (ignore area))
  (format t "drawing ~S x ~S~%" width height)
  (let ((w (coerce (the (signed-byte 32) width)  'single-float))
        (h (coerce (the (signed-byte 32) height) 'single-float)))
    (let ((hw (/ w 2))
          (hh (/ h 2)))
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

        ;; grid background
        (with-gdk-rgba (color "#777777CC")
          (gdk:cairo-set-source-rgba cr color))
        (square-centered-at hw hh (+ (* size 3) (* size 0.20)))

        ;; grid
        (with-gdk-rgba (color "#FFFFFFCC")
          (gdk:cairo-set-source-rgba cr color))
        (square-centered-at (- hw dist) (- hh dist) size)
        (square-centered-at (- hw dist) hh size)
        (square-centered-at (- hw dist) (+ hh dist) size)

        (square-centered-at hw (- hh dist) size)
        (square-centered-at hw hh size)
        (square-centered-at hw (+ hh dist) size)

        (square-centered-at (+ hw dist) (- hh dist) size)
        (square-centered-at (+ hw dist) hh size)
        (square-centered-at (+ hw dist) (+ hh dist) size)

        ;; top bar
        (with-gdk-rgba (color "#BBBBBBCC")
          (gdk:cairo-set-source-rgba cr color))

        (cairo:rectangle (- hw (* size 2))
                         (- hh (* size 2.3))
                         (* size 4)
                         (* size 0.67))
        (cairo:fill-path)

        ;; bottom bar
        (with-gdk-rgba (color "#FFFFBBCC")
          (gdk:cairo-set-source-rgba cr color))
        (cairo:rectangle (- hw (* size 2))
                         (+ hh (* size 1.62))
                         (* size 4)
                         (* size 0.67))
        (cairo:fill-path)

        ;; help area
        (with-gdk-rgba (color "#88FFFFAA")
          (gdk:cairo-set-source-rgba cr color))
        (cairo:rectangle (- hw (* size 2) 10)
                         (- hh (* size 2))
                         (+ (* size 4) (* 2 10))
                         (* size 4))
        (cairo:fill-path)

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
;;; keys =======================================================================

(defun check-key (key-val key-code key-modifiers)
  (declare (ignore key-code))
  (let ((enterable (< (integer-length key-val) 16)))
    (format t "~a ~S ~S~%"
            (when enterable
              (code-char key-val))
            (gdk4:keyval-name key-val)
            (modifiers key-modifiers))))

;; https://gitlab.gnome.org/GNOME/gtk/-/blob/main/gdk/gdkkeysyms.h
(defun modifiers (modifiers)
  (let ((names '(:shift "1" :ctrl :alt "4" "5" "6" :gr "8" "9" "10" "11" "12"
                 "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24"
                 "25" :win)))
    (loop for x = 0 then (1+ x)
          for n in names
          when (and (plusp (ldb (byte 1 x) modifiers))
                    (typep n 'keyword))
            collect n)))

;;; ============================================================================


;;; TODO Add more code here.

;;; ===================================0=========================================
;;; main =======================================================================

;;; STARTING
;; (load "~/Programming/Pyrulis/Lisp/cl-gtk4-tictactoe.lisp")
;; (in-package #:cl-gtk4-tictactoe)

(defun main ()
  (let ((app (make-application :application-id "org.bigos.cl-gtk4-tictactoe"
                               :flags gio:+application-flags-flags-none+)))
    (connect app "activate"
             (lambda (app)
               (let ((window (make-application-window :application app)))

                 (glib:timeout-add 1000 (lambda (&rest args)
                                          (format t "timeout ~S~%" args)
                                          glib:+priority-default+))

                 ;; for some reason these do not work
                 ;; (let ((focus-controller (gtk4:make-event-controller-focus)))
                 ;;   (widget-add-controller window focus-controller)
                 ;;   (connect focus-controller "enter" (lambda (event &rest args)
                 ;;                                       (format t "focus enter  ~S ~S~%" (slot-value event 'class) args)))
                 ;;   (connect focus-controller "leave" (lambda (event &rest args)
                 ;;                                       (format t "focus leave ~S ~S~%"  (slot-value event 'class) args))))

                 (let ((key-controller (gtk4:make-event-controller-key)))
                   (widget-add-controller window key-controller)
                   (connect key-controller "key-pressed" (lambda (event key-val key-code key-modifiers)
                                                           (format t "key-pressed ~S~%"  (find-class (type-of (slot-value event 'class))))
                                                           (check-key key-val key-code key-modifiers))))

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
                     (let ((motion-controller (gtk4:make-event-controller-motion)))
                       (widget-add-controller canvas motion-controller)
                       (connect motion-controller "motion" (lambda (event x y )
                                                             (declare (ignore event x y))
                                                             ;; (format t "Mouse motion ~S ~S ~S~%" (slot-value event 'class) x y)
                                                             ))
                       (connect motion-controller "enter" (lambda (event x y )
                                                            (format t "Mouse enter ~S ~S ~S~%" (slot-value event 'class) x y)))
                       (connect motion-controller "leave" (lambda (event)
                                                            (format t "Mouse leave ~S~%" (slot-value event 'class)))))
                     (let ((gesture-click-controller (gtk4:make-gesture-click)))
                       (widget-add-controller canvas gesture-click-controller)
                       (connect gesture-click-controller "pressed" (lambda (event n-press x y)
                                                                     (format t "mouse pressed ~S ~S ~S ~S~%" (slot-value event 'class) n-press x y)))
                       (connect gesture-click-controller "released" (lambda (event n-press x y)
                                                                      (format t "mouse released ~S ~S ~S ~S~%" (slot-value event 'class) n-press x y))))



                     (box-append box canvas))
                   (setf (window-child window)
                         box))
                 (window-present window))))
    (gio:application-run app nil)))

;;; T for terminal
(when nil
  (main)
  (sb-ext:quit))
