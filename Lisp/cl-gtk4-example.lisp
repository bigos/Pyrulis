(declaim (optimize (speed 0) (safety 2) (debug 3)))

(cl:in-package "CL-USER")

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(cl-gtk4
                  cl-gdk4
                  cl-glib
                  cl-cairo2
                  serapeum
                  defclass-std
                  fiveam)))

;;; cairo tweaks ===============================================================
(defpackage #:cairo-gobject
  (:use)
  (:export #:*ns*))

(in-package #:cairo-gobject)

(gir-wrapper:define-gir-namespace "cairo")

;;; my example package =========================================================
(cl:in-package "CL-USER") ; make sure you come back to cl-user because the previous package does not use it

(defpackage #:cl-gtk4-example ; ------------------------------------------------
  (:use :cl #:gtk4)
  (:import-from :defclass-std
   :defclass/std)
  (:import-from :serapeum
   :~>) )

;; (load "~/Programming/Pyrulis/Lisp/cl-gtk4-example.lisp")
(in-package #:cl-gtk4-example)

;;; drawing - macro for colours ------------------------------------------------

;; https://github.com/bohonghuang/cl-gtk4/blob/master/examples/gdk4-cairo.lisp
(cffi:defcstruct gdk-rgba
  (red :double)
  (green :double)
  (blue :double)
  (alpha :double))

(defmacro with-gdk-rgba ((pointer color) &body body)
  `(locally
       #+sbcl (declare (sb-ext:muffle-conditions sb-ext:compiler-note))
       (cffi:with-foreign-object (,pointer '(:struct gdk-rgba))
         (let ((,pointer (make-instance 'gir::struct-instance
                                        :class (gir:nget gdk::*ns* "RGBA")
                                        :this ,pointer)))
           (gdk:rgba-parse ,pointer ,color)
           (locally
               #+sbcl (declare (sb-ext:unmuffle-conditions sb-ext:compiler-note))
               ,@body)))))

;;; drawing- draw-func ---------------------------------------------------------
(defun draw-func (area cr width height)
  (declare (ignore area)
           (optimize (speed 3)
                     (debug 0)
                     (safety 0)))
  (let ((width (coerce (the fixnum width) 'single-float))
        (height (coerce (the fixnum height) 'single-float))
        (fpi (coerce pi 'single-float)))
    (let* ((radius (/ (min width height) 2.0))
           (stroke-width (/ radius 8.0))
           (button-radius (* radius 0.4)))
      (declare (type single-float radius stroke-width button-radius))

      (with-gdk-rgba (color "#000000")
        (cairo:arc (/ width 2.0) (/ height 2.0) button-radius 0.0 (* 2.0 fpi))
        (gdk:cairo-set-source-rgba cr color)
        (cairo:fill-path))
      (with-gdk-rgba (color "#AAFFAAFF")
        (cairo:arc (/ width 2.0) (/ height 2.0) (- button-radius stroke-width) 0.0 (* 2.0 fpi))
        (gdk:cairo-set-source-rgba cr color)
        (cairo:fill-path)))))

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

;;; event sink -----------------------------------------------------------------

(defun event-sink-test (signal-name event-class &rest args)
  (event-sink% nil signal-name event-class args))

(defun event-sink (widget signal-name event &rest args)
  (let ((event-class (when event (format nil "~S" (slot-value event 'class)))))
    (unless (member signal-name '("motion" "timeout")
                    :test #'equalp)
      (format t "EEEEEEEEEEEEEEEEE ~S ~S ~S~%"
              event-class
              signal-name
              args))
    (event-sink% widget signal-name event-class args)))

(defun event-sink% (widget signal-name event-class args)
  (cond
    ((equalp event-class "#O<SimpleAction>")
     (cond                              ; manu
       ((equalp signal-name "activate")
        (format t "meeeennu ~S ~%" widget)
        (cond
          ((equalp widget "menu-item-quit")
           ;; this quits the app by closing all the windows
           ;; (loop for aw = (gtk4:application-active-window (current-app))
           ;;       until (null aw)
           ;;       do (gtk4:window-close aw))
           (warn "implement closing"))
          (T (warn "unknown simple action widget ~S" widget))))
       (t (error "unknown signal ~S~%" signal-name))))
    (T
     (warn "unknown event class ~S" event-class))))

;;; menu -----------------------------------------------------------------------
(defun make-detailed-action (app action-name fn)
  (let ((act (gio:make-simple-action :name action-name :parameter-type nil)))
    (gio:action-map-add-action app act)
    (connect act "activate" fn)

    (format nil "app.~A" action-name)))

(defun make-my-menu-item (app label action-name item-name)
  (gio:make-menu-item :label label
                      :detailed-action
                      (make-detailed-action app action-name
                                            (lambda (event &rest args)
                                              (event-sink item-name
                                                          "activate"
                                                          event args)))))

(defun main-menubar (app menubar)
  (let* ((menubar-item-menu (gio:make-menu-item :label "Menu" :detailed-action nil ))
         (menu (gio:make-menu))
         (menu-item-quit
           (make-my-menu-item app "Quit" "quit" "menu-item-quit")))

    (loop for mi in (list
                     menu-item-quit)
          do (gio:menu-append-item menu mi))
    (setf (gio:menu-item-submenu menubar-item-menu) menu)
    (gio:menu-append-item menubar menubar-item-menu)))

;;; main function --------------------------------------------------------------
(defun main ()
  (let ((app (make-application :application-id "org.bohonghuang.cl-gdk4-cairo-example"
                               :flags gio:+application-flags-flags-none+)))
    (connect app "activate"
             (lambda (app)
               (let ((window (make-application-window :application app)))
                 (setf (window-title window) "Drawing Area Test")
                 (let ((area (gtk:make-drawing-area)))
                   (setf (drawing-area-content-width area) 200
                         (drawing-area-content-height area) 200
                         (drawing-area-draw-func area) (list (cffi:callback %draw-func)
                                                             (cffi:null-pointer)
                                                             (cffi:null-pointer)))
                   (setf (window-child window) area))

                 (let ((menubar (gio:make-menu)))
                   (main-menubar app menubar)
                   (setf (gtk4:application-menubar app) menubar))
                 (setf (gtk4:application-window-show-menubar-p window) T)

                 (window-present window))))
    (application-run app nil)))
