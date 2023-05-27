(declaim (optimize (speed 0) (safety 2) (debug 3)))

;;; popoever examples
;; https://discourse.gnome.org/t/how-do-i-position-a-gtk-popovermenu-at-the-mouse-pointer-coordinates/10620/3
;; https://python-gtk-3-tutorial.readthedocs.io/en/latest/popover.html

;;; This is a very simple example for starting gui projects
;;; (load "~/Programming/Pyrulis/Lisp/gui.lisp")

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(
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

(defun symbolize (obj)
  (intern (typecase obj
            (gir::object-instance
             (subseq (format nil "~a" (slot-value obj 'class))
                     2))
            (t
             (format nil "~A" obj)))))

(defmethod event-sink :before (widget signal-name args)
  (assert (typep widget      'keyword))
  (assert (typep signal-name 'keyword))

  (unless (member signal-name '(:motion :timeout))
    (format t "~&<<=================<< event ~S~%" (list widget signal-name args))))

(defmethod event-sink (widget signal-name args)
  (format t "~&unhandled event ~S~%" (list widget signal-name args)))

(defmethod event-sink (widget (signal-name (eql :timeout)) args)
  ;; (format t "T ")
  )

(defmethod event-sink (widget (signal-name (eql :motion)) args)
  ;; (format t "M ")
  )

(defmethod event-sink (widget (signal-name (eql :key-pressed)) args)
  (format t "key pressed ~S~%" args))

(defmethod event-sink ((widget (eql :canvas)) (signal-name (eql :pressed)) args)
  (format t "mouse key pressed ~S~%" args)
  (destructuring-bind (button count x y) args
    (declare (ignore count))
    (case button
      (3 (progn
           (format t "right click~%")
         )))))

(defmethod event-sink ((widget (eql :canvas)) (signal-name (eql :released)) args)
  (format t "mouse key released ~S~%" args))

(defmethod event-sink ((widget (eql :menu)) (signal-name (eql :activate)) args)
  (format t "~&menu ~S~%" (list widget signal-name args ))
  (case args
    (|file/open|
     (add-window (current-app)))
    (|file/exit|
     (close-all-windows-and-quit))
    (|help/about|
     (let ((dialog (menu-test-about-dialog)))
       (setf (window-modal-p dialog) t
             (window-transient-for dialog) (current-active-window))
       (window-present dialog)))
    (t (warn "case for ~S fell through" args))))

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

(defun menu-test-menu (app window)
  (declare (ignore window))
  (let ((menu (gio:make-menu)))
    (let ((submenu (gio:make-menu)))
      (gio:menu-append-submenu menu "File" submenu)

      (gio:menu-append-item submenu (gio:make-menu-item :model menu :label "Open" :detailed-action "app.open"))
      (define-and-connect-action app "open" "file/open")

      (gio:menu-append-item submenu (gio:make-menu-item :model menu :label "Exit" :detailed-action "app.exit"))
      (define-and-connect-action app "exit" "file/exit"))
    (let ((submenu (gio:make-menu)))
      (gio:menu-append-submenu menu "Help" submenu)

      (gio:menu-append-item submenu (gio:make-menu-item :model menu :label "About" :detailed-action "app.about"))
      (define-and-connect-action app "about" "help/about"))
    menu))

(defun menu-test-popover (app window)
  (declare (ignore window))
  (let ((submenu (gio:make-menu)))
    ;; aaarg! changing application theme in system Setting has fixed the problem

    (gio:menu-append-item submenu (gio:make-menu-item :label "Opt 1" :detailed-action "app.option1"))
    (define-and-connect-action app "option1" "popover/option1")

    (gio:menu-append-item submenu (gio:make-menu-item :label "Opt 2" :detailed-action "app.option2"))
    (define-and-connect-action app "option2" "popover/option2")
    submenu))

(defun define-and-connect-action (app action-name menu-dir)
  (let ((action (gio:make-simple-action :name action-name
                                        :parameter-type nil)))
    (gio:action-map-add-action app action)
    (connect-action action "activate" (symbolize menu-dir))))

;;; events and gui =========================
(defun connect-action (action signal-name menu-dir)
  (connect action signal-name
           (lambda (event args)
             (declare (ignore event args))
             (apply #'event-sink
                    (list :menu
                          :activate
                          menu-dir)))))

;;; signal key is for event sink signal name is for gtk4
(defun connect-controller (widget controller signal-name signal-key &optional (args-fn #'identity))
  (connect controller signal-name
           (lambda (event &rest args)
             (declare (ignore event))
             (apply #'event-sink
                    (list widget
                          signal-key
                          (funcall args-fn args))))))

(defun connect-geture-click-controller (widget controller signal-name signal-key popover &optional (args-fn #'identity))
  (connect controller signal-name
           (lambda (event &rest args)
             (let ((current-button (gesture-single-current-button event)))
               (when (and (eq signal-key :pressed)
                          (eq 3 current-button))
                 (format t "before rectangle and popover~%")
                 (cffi:with-foreign-object (rect '(:struct gdk4:rectangle))
                   (cffi:with-foreign-slots ((gdk::x gdk::y gdk::width gdk::height) rect (:struct gdk4:rectangle))
                     (setf gdk::x (round (nth 1 args))
                           gdk::y (round (nth 2 args))
                           gdk::width (round 0)
                           gdk::height (round 0)))
                   (setf
                    (popover-pointing-to popover) (gobj:pointer-object rect 'gdk:rectangle)))

                 (format t "~%~%==============popover================~S~%~%" args)
                 (gtk4:popover-popup popover))

               (apply #'event-sink
                      (list widget
                            signal-key
                            (funcall args-fn
                                     (cons current-button
                                           args))))))))

(defun window-events (window)
  (glib:timeout-add 1000
                    (lambda (&rest args)
                      (apply #'event-sink
                             (list :window :timeout args))
                      glib:+source-continue+))

  (let ((key-controller (gtk4:make-event-controller-key)))
    (widget-add-controller window key-controller)
    (connect-controller :window key-controller "key-pressed" :key-pressed #'translate-key-args)))

(defun canvas-events (canvas popover)
  (let ((motion-controller (gtk4:make-event-controller-motion)))
    (widget-add-controller canvas motion-controller)
    (connect-controller :canvas motion-controller "motion" :motion)
    (connect-controller :canvas motion-controller "enter" :enter)
    (connect-controller :canvas motion-controller "leave" :leave))

  (let ((gesture-click-controller (gtk4:make-gesture-click)))
    ;; make gesture click listen to other mouse buttons as well
    (setf (gesture-single-button gesture-click-controller) 0)

    (widget-add-controller canvas gesture-click-controller)
    (connect-geture-click-controller :canvas gesture-click-controller "pressed"  :pressed  popover)
    (connect-geture-click-controller :canvas gesture-click-controller "released" :released popover))

  (connect canvas "resize" (lambda (widget &rest args)
                             (declare (ignore widget))
                             (apply #'event-sink
                                    (list :canvas :resize args)))))

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
        (format t "before popover creation~%")
        (let ((popover (gtk4:make-popover-menu  :model (menu-test-popover app window))))

          (setf (gtk4:widget-parent popover) canvas)
          (gtk4:popover-present popover)

          (canvas-events canvas popover))

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
