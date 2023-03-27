(declaim (optimize (speed 0) (safety 2) (debug 3)))

;;; This is a very simple example for starting gui projects
;;; (load "~/Programming/Pyrulis/Lisp/gui.lisp")

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(serapeum
                  cl-gtk4
                  cl-gdk4
                  cl-cairo2
                  cl-glib
                  defclass-std)))

(in-package "COMMON-LISP-USER")

(defpackage #:cairo-gobject
  (:use)
  (:export #:*ns*))
(cl:in-package #:cairo-gobject)
(gir-wrapper:define-gir-namespace "cairo")

(cl:in-package "COMMON-LISP-USER")

(use-package 'gtk4)
(shadowing-import 'defclass-std::defclass/std)

(defclass/std guiz ()
  ((zzz :std 1)))

;;; drawing =========================
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

(defun draw-func (area cr width height)
  (declare (ignore area)
           (optimize (speed 3)
                     (debug 0)
                     (safety 0)))
  (let ((w (coerce (the (signed-byte 32) width)  'single-float))
        (h (coerce (the (signed-byte 32) height) 'single-float))
        (fpi (coerce pi 'single-float)))

    (cairo:move-to 0.0 0.0)
    (cairo:line-to w h)
    (with-gdk-rgba (color "#227722FF")
      (gdk:cairo-set-source-rgba cr color))
    (cairo:stroke)))

;;; event sink =============================

;;; used for testing
(defun event-sink-test (signal-name event-class &rest args)
  (event-sink% nil signal-name event-class args))

(defun event-sink (widget signal-name event &rest args)
  (let ((event-class (when event (format nil "~S" (slot-value event 'class)))))
    (event-sink% widget signal-name event-class args)))

(defun event-sink% (widget signal-name event-class args)
  (unless (member signal-name (list "timeout" "motion") :test #'equalp)
    (format t "~&event sink ~S~%" (list widget signal-name event-class args))))

;;; menu ===================================
(defun menu-test-about-dialog ()
  (let ((dialog (make-about-dialog)))
    (setf (about-dialog-authors dialog) (list "Jacek Podkanski")
          (about-dialog-website dialog) "https://github.com/bigos/Pyrulis/blob/master/Lisp/gui.lisp"
          (about-dialog-version dialog) "early-alpha-0.1"
          (about-dialog-program-name dialog) "Cairo, Gui and menu test"
          (about-dialog-comments dialog) "This is a cl-gtk4 test."
          (about-dialog-logo-icon-name dialog) "application-x-addon")
    (values dialog)))

(defun menu-test-menu (app)
  (let ((menu (gio:make-menu)))
    (let ((submenu (gio:make-menu)))
      (gio:menu-append-submenu menu "File" submenu)
      (gio:menu-append-item submenu (gio:make-menu-item :model menu :label "Open" :detailed-action "app.open"))
      (let ((action (gio:make-simple-action :name "open"
                                            :parameter-type nil)))
        (gio:action-map-add-action app action)
        (connect action "activate"
                 (lambda (action param)
                   (declare (ignore action param))
                   (add-window app))))

      (gio:menu-append-item submenu (gio:make-menu-item :model menu :label "Exit" :detailed-action "app.exit"))
      (let ((action (gio:make-simple-action :name "exit"
                                            :parameter-type nil)))
        (gio:action-map-add-action app action)
        (connect action "activate"
                 (lambda (action param)
                   (declare (ignore action param))
                   (close-all-windows-and-quit)))))
    (let ((submenu (gio:make-menu)))
      (gio:menu-append-submenu menu "Help" submenu)
      (gio:menu-append-item submenu (gio:make-menu-item :model menu :label "About" :detailed-action "app.about"))
      (let ((action (gio:make-simple-action :name "about"
                                            :parameter-type nil)))
        (gio:action-map-add-action app action)
        (connect action "activate"
                 (lambda (action param)
                   (declare (ignore action param))
                   (let ((dialog (menu-test-about-dialog)))
                     (setf (window-modal-p dialog) t
                           (window-transient-for dialog) window)
                     (window-present dialog))))))
    menu))



;;; events and gui =========================
(defun connect-controller (widget controller signal-name)
  (connect controller signal-name (lambda (event &rest args)
                                    (event-sink widget signal-name event args))))

(defun window-events (window)
  (glib:timeout-add 1000
                    (lambda (&rest args)
                      (event-sink window "timeout" nil args)
                      glib:+source-continue+))
  (let ((key-controller (gtk4:make-event-controller-key)))
    (widget-add-controller window key-controller)
    (connect-controller window key-controller "key-pressed")
    (connect-controller window key-controller "key-released")))

(defun canvas-events (canvas)
  (let ((motion-controller (gtk4:make-event-controller-motion)))
    (widget-add-controller canvas motion-controller)
    (connect-controller canvas motion-controller "motion")
    (connect-controller canvas motion-controller "enter")
    (connect-controller canvas motion-controller "leave"))

  (let ((gesture-click-controller (gtk4:make-gesture-click)))
    (widget-add-controller canvas gesture-click-controller)
    (connect-controller canvas gesture-click-controller "pressed")
    (connect-controller canvas gesture-click-controller "released"))

  (connect canvas "resize" (lambda (widget &rest args)
                             (declare (ignore widget))
                             (event-sink canvas "resize" nil args))))

(defun add-window-menu (app window)
  (setf (gtk4:application-menubar app) (menu-test-menu app))
  (setf (gtk4:application-window-show-menubar-p window) T))

(defun add-window (app)
  (let ((window (make-application-window :application app)))
    (add-window-menu app window)

    (setf (window-title window) "GUI"
          (window-default-size window) (list 300 300))
    (window-events window)

    (let ((box (make-box :orientation +orientation-vertical+
                         :spacing 0)))

      (let ((canvas (make-drawing-area)))
        (setf (drawing-area-content-width canvas) 200
              (drawing-area-content-height canvas) 200
              (widget-vexpand-p canvas) T
              (widget-hexpand-p canvas) T
              (drawing-area-draw-func canvas) (list (cffi:callback %draw-func)
                                                    (cffi:null-pointer)
                                                    (cffi:null-pointer)))
        (canvas-events canvas)

        (box-append box canvas))
      (setf (window-child window) box))

    (window-present window)))

(defun connect-activate (app)
  (format t "going to add window ")
  (add-window app))

(defun close-all-windows-and-quit ()
  (loop for aw = (gtk4:application-active-window (current-app))
        until (null aw)
        do (gtk4:window-close aw)))

;;; main ===============================================
(defparameter *application* nil)

(defun current-app () *application*)

(defun main ()
  (let ((app (make-application :application-id "org.bigos.simple.gui"
                               :flags gio:+application-flags-flags-none+)))
    (setf *application* app)

    (connect app "activate"
             (lambda (app)
               (connect-activate app)))
    (let ((stat (gio:application-run app nil)))
      stat)))
