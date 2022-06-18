(declaim (optimize (speed 1) (safety 2) (debug 3)))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(:draw-cons-tree :alexandria :serapeum :cl-cffi-gtk :defclass-std)))

(require 'sb-concurrency)

(defpackage :vvv
  (:use #:cl
        #:cffi
        #:gtk #:gdk #:gdk-pixbuf #:gobject #:glib #:gio #:pango #:cairo))
;; (load "~/Programming/Pyrulis/Lisp/vvv.lisp")
(in-package :vvv)

;;---------------------------------------------------------------------;;
;; example minimal project for experimenting with cairo and key events ;;
;;---------------------------------------------------------------------;;

;;; * clos ********************************************

(defclass-std:defclass/std app ()
  ((gtk-app)))

(defmethod quit ((obj app))
  (loop for w in (gtk-application-get-windows (gtk-app obj))
        do (format t "closing window~%")
           (gtk-window-close w))
  (format t "trying to quit~%")
    (g-signal-emit (gtk-app obj) "shutdown"))

(defmethod draw-view ((cr sb-sys:system-area-pointer))
  ;; add more drawing later
  (cairo-set-source-rgb cr 0.7 1.0 1.0)
  (cairo-paint cr))

;;; * normal events ******************************************
(defmethod draw-canvas (obj (widget gtk-drawing-area) (context cairo-context))  ;VIEW
  (let ((cr (pointer context)))
    (cairo-reference cr)
    ;;
    (draw-view cr) ;; in real example we will need the model as well
    ;;
    (cairo-destroy cr)))

(defmethod widget-event ((obj app) (widget gtk-application-window) (event gdk-event-key))
  (warn "processing event ~S ~S ~S" obj widget event)
  (case (gdk-event-key-type event)
    (:key-press (cond
                  ((and (equal (gdk-event-key-string event) "q")
                        (equal (gdk-event-key-state event) '(:MOD1-MASK)))
                   (quit obj))
                  (t
                   nil)))
    (:key-release (warn "unimplemented event ~S ~S ~S" obj widget event))
    (otherwise (error "should not end here"))))

(defmethod widget-event (obj (widget gtk-drawing-area) (event gdk-event-motion))
  (when nil (warn "unimplemented canvas motion event")))

(defmethod widget-event (obj widget event)
  (warn "unimplemented event ~S ~S ~S ~S" (type-of obj) (type-of widget) (type-of event) (gdk-event-type event)))

;;; * basic events ******************************************
(defmethod win-delete-event ((obj app) (widget gtk-application-window) event)
  (declare (ignore widget))
  "Event for graceful closing of the window."
  (format t "Delete Event occurred.~A~%" event)
  (if (progn
        (warn "finish win-delete-event-fun condition")
        T)
      (progn
        (format t "~&QUITTING~%")
        (leave-gtk-main)
        +gdk-event-propagate+)

      (progn
        (format t "the window was not permitted to close~A~% ")
        +gdk-event-stop+)))

(defmethod add-new-window ((obj app) app)
  (let ((window (make-instance 'gtk-application-window
                               :application app
                               :title "VVV experiment window"
                               :default-width 500
                               :default-height 300))
        (box (make-instance 'gtk-box
                            :border-width 1
                            :orientation :vertical
                            :spacing 1))
        (canvas (make-instance 'gtk-drawing-area
                               :width-request 500
                               :height-request 270)))

    ;; packing widgets
    (gtk-container-add window box)
    (gtk-box-pack-start box canvas)

    ;; signals

    ;; canvas events inherited from the widget
    (loop for ev in (list "configure-event"
                          "motion-notify-event"
                          "scroll-event"
                          "button-press-event"
                          "button-release-event")
          do (g-signal-connect canvas ev (lambda (widget event)
                                           (widget-event obj widget event))))

    ;; canvas events
    ;; this does the VIEW part of out architecture
    (g-signal-connect canvas "draw" (lambda (widget context)
                                      (draw-canvas obj widget context)))

    (gtk-widget-add-events canvas '(:all-events-mask))

    ;; window events inherited form the widget
    (loop for ev in (list "key-press-event"
                          "key-release-event"
                          "enter-notify-event"
                          "leave-notify-event")
          do (g-signal-connect window ev (lambda (widget event)
                                           (widget-event obj widget event))))

    ;; Signal handler for closing the window and to handle the signal "delete-event".
    (g-signal-connect window "delete-event" (lambda (widget event)
                                              (win-delete-event obj widget event)))

    ;; finally show all widgets
    (gtk-widget-show-all window)))

;;; * main ******************************************
(defun main ()
  (let* ((gtk-app (gtk-application-new "vvv.window" :none))
         (appl (make-instance 'app :gtk-app gtk-app)))

    (g-signal-connect gtk-app "activate" (lambda (a) (add-new-window appl a)))
    (let ((status (g-application-run gtk-app 0 (null-pointer))))
      (g-object-unref (pointer gtk-app))
      status)))
