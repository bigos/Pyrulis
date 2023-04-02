(declaim (optimize (speed 0) (safety 2) (debug 3)))

;;; This is a very simple example for starting gui projects
;;; (load "~/Programming/Pyrulis/Lisp/gui.lisp")

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(serapeum
                  alexandria
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

;;; sink =============================

(defun symbilize (obj)
  (intern (typecase obj
            (gir::object-instance
             (subseq (format nil "~S" (slot-value obj 'class))
                     3))
            (t
             (format nil "~S" obj)))))

(defun event-sink (widget signal-name event &rest args)
  (event-sink2 (symbilize widget)
               (symbilize signal-name)
               (when event
                 (symbilize event))
               args))

(defun event-sink2 (widget signal-name event args)
  (case widget
    (|ApplicationWindow>|
     (case event
       (timeout                          ;ignored so far
        )
       (|EventControllerKey>|
        (case signal-name
          (otherwise (warn "unexpected key signal ~S ~S" signal-name args))))
       (otherwise (warn "unexpected window event ~S ~S" event args))))
    (|DrawingArea>|
     (case event
       (|EventControllerMotion>|        ;ignored so far
        )
       (otherwise (warn "unexpected canvas event ~S ~S" event args))))
    (|Menu>|
     (case event
       (|SimpleAction>|
        (cond
          ((equalp (caar args) "file/exit")
           (close-all-windows-and-quit))
          ((equalp (caar args) "file/open")
           (add-window (current-app)))
          ((equalp (caar args) "help/about")
           (let ((dialog (menu-test-about-dialog)))
             (setf (window-modal-p dialog) t
                   (window-transient-for dialog) (current-active-window))
             (window-present dialog)))
          (t (warn "unhandled menu event ~S" args))))
       (otherwise (warn "unexcpected menu event ~S ~S" event args))))
    (otherwise (warn "unexpected widget ~S ~S" widget args))))

(defparameter *comment-on-event-structure*
  '(sink
    (widget
     (window
      (timeout)
      (key-pressed)
      (key-released))
     (canvas
      (motion)
      (resize)
      (enter)
      (leave))
     (menu
      (activate
       ("file/open")
       ("file/exit")
       ("help/about")))))
  "proposed widget event structure")

;;; translate key args =====================
(defun translate-key-args (args)
  (destructuring-bind (keyval keycode keymods) args
    (list
     (format nil "~A"
             (let ((unicode (gdk:keyval-to-unicode keyval)))
               (if (or (zerop unicode)
                       (member keyval
                               (list gdk:+key-escape+
                                     gdk:+key-backspace+
                                     gdk:+key-delete+)))
                   ""
                   (code-char unicode))))
     (gdk:keyval-name keyval)
     keycode
     (remove-if (lambda (m) (member m '(:num-lock)))
                (loop
                  for modname in '(:shift :caps-lock :ctrl :alt
                                   :num-lock :k6 :win :alt-gr)
                  for x = 0 then (1+ x)
                  for modcode = (mask-field (byte 1 x) keymods)
                  unless (zerop modcode)
                    collect modname)))))

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

(defun define-and-connect-action (app action-name submenu menu-dir)
  (let ((action (gio:make-simple-action :name action-name
                                        :parameter-type nil)))
    (gio:action-map-add-action app action)
    (connect-action submenu action "activate" (lambda (args)
                                                (declare (ignore args))
                                                 (list menu-dir)))))

(defun menu-test-menu (app window)
  (declare (ignore window))
  (let ((menu (gio:make-menu)))
    (let ((submenu (gio:make-menu)))
      (gio:menu-append-submenu menu "File" submenu)

      (gio:menu-append-item submenu (gio:make-menu-item :model menu :label "Open" :detailed-action "app.open"))
      (define-and-connect-action app "open" submenu "file/open")

      (gio:menu-append-item submenu (gio:make-menu-item :model menu :label "Exit" :detailed-action "app.exit"))
      (define-and-connect-action app "exit" submenu "file/exit"))
    (let ((submenu (gio:make-menu)))
      (gio:menu-append-submenu menu "Help" submenu)

      (gio:menu-append-item submenu (gio:make-menu-item :model menu :label "About" :detailed-action "app.about"))
      (define-and-connect-action app "about" submenu "help/about"))
    menu))

;;; events and gui =========================
(defun connect-action (submenu action signal-name &optional (args-fn #'identity))
  (connect action signal-name
           (lambda (event args)
             (event-sink submenu
                         signal-name
                         event
                         (funcall args-fn args)))))

(defun connect-controller (widget controller signal-name &optional (args-fn #'identity))
  (connect controller signal-name
           (lambda (event &rest args)
             (event-sink widget
                         signal-name
                         event
                         (funcall args-fn args)))))

(defun window-events (window)
  (glib:timeout-add 1000
                    (lambda (&rest args)
                      (event-sink window "timeout" 'timeout args)
                      glib:+source-continue+))
  (let ((key-controller (gtk4:make-event-controller-key)))
    (widget-add-controller window key-controller)
    (connect-controller window key-controller "key-pressed" #'translate-key-args)))

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
                             (event-sink widget "resize" 'resize args))))

(defun add-window-menu (app window)
  (setf (gtk4:application-menubar app) (menu-test-menu app window))
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
  (loop for aw = (current-active-window)
        until (null aw)
        do (gtk4:window-close aw)))

;;; main ===============================================
(defparameter *application* nil)

(defun current-active-window () (gtk4:application-active-window (current-app)))

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
