(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(:alexandria :serapeum :cl-cffi-gtk)))

(defpackage #:window
  (:use #:cl
        #:cffi
        #:gtk #:gdk #:gdk-pixbuf #:gobject #:glib #:gio #:pango #:cairo))

;; (load "/home/jacek/Programming/Pyrulis/Lisp/window.lisp")
(in-package :window)

;;; canvas======================================================================
(defun draw-canvas (model canvas context)
  (let* ((w (gtk-widget-get-allocated-width canvas))
         (h (gtk-widget-get-allocated-height canvas))
         (cr (pointer context)))
    ;; prevent cr being destroyed improperly
    (cairo-reference cr)

    (draw-canvas-lines cr model)

    ;; cleanup
    ;; cairo destroy must have matching cairo-reference
    (cairo-destroy cr)

    ;; continue propagation of the event handler
    +gdk-event-propagate+))

(defun draw-canvas-lines (cr model)
  (cairo-set-source-rgb cr 0.6 0.9 0)
  (cairo-set-line-width cr 25)
  (cairo-set-line-cap cr :round)
  (cairo-set-line-join cr :round)

  ;; draw dots
  (cairo-set-source-rgb cr 0.4 0.6 0.1)
  (cairo-set-line-width cr 13)
  (loop for c in model
        do (cairo-move-to cr
                          (* 1 (car c))
                          (* 1 (cdr c)))
           (cairo-line-to cr
                          (* 1 (car c))
                          (* 1 (cdr c)) ))
  (cairo-stroke cr))

;;; TODO play with drawing on canvas
;; file:~/quicklisp/dists/quicklisp/software/cl-cffi-gtk-20201220-git/demo/cairo-demo/cairo-demo.lisp::1
;; file:~/Programming/Pyrulis/Lisp/cairo-snake/cairo-snake.lisp::282
(defun draw-fun (canvas context)
  (let ((model *model*))
    (format t "model is ~A~%" model)
    (draw-canvas model canvas context)))

;;; event handling==============================================================
(defun canvas-event-fun (widget event)
  (typecase event
    (gdk-event-configure (format T "c"))
    (gdk-event-motion (format T "-"))
    (gdk-event-button (if (equal (gdk-event-button-type event) :button-release)  ; mouse button
                          (format T "~&~A ~A~%"
                                  (gdk-event-button-type event)
                                  (gdk-event-button-button event))
                          (progn

                            (push
                             (cons
                              (gdk-event-button-x event)
                              (gdk-event-button-y event))
                             *model*)
                            (gtk-widget-queue-draw widget)
                            (format T "~&EEE b~A ~A~%" (gdk-event-button-type event) event))))
    (t (error "not implemented ~A~%" (type-of event))))
  +gdk-event-propagate+)

;;; event for graceful closing of the window
(defun win-delete-event-fun (widget event)
  (declare (ignore widget))
  (format t "Delete Event Occured.~A~%" event)
  (if (zerop *do-not-quit*)
      (progn
        (format t "~&QUITTING~%")
        (leave-gtk-main)
        +gdk-event-propagate+)

      (progn
        (decf *do-not-quit*)
        (format t "~&not quitting yet ~A clicks more on close widget to go~%" (+ 1 *do-not-quit*))
        +gdk-event-stop+)))

;;; event handling helpers======================================================

;;; windows ====================================================================
(defun add-new-window (app)
  (let ((window (make-instance 'gtk-application-window
                               :application app
                               :title "New and better window"
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

    ;; drawing-area signals
    (g-signal-connect canvas "draw"
                      (lambda (widget context)
                        (draw-fun widget context)))

    ;; add to canvas events inherited from widget
    (loop for ev in (list "configure-event"
                          "motion-notify-event"
                          "button-press-event"
                          "button-release-event")
          do (g-signal-connect canvas ev #'canvas-event-fun))
    (gtk-widget-add-events canvas '(:all-events-mask))

    ;; Signal handler for closing the window and to handle the signal "delete-event".
    (g-signal-connect window "delete-event" #'win-delete-event-fun)

    ;; finally show all widgets
    (gtk-widget-show-all window)))

(defvar *global-app* nil)
(defvar *do-not-quit* 3)
(defvar *model* nil)
;; https://www.gtk.org/docs/getting-started/hello-world/
(defun main-app ()
  (let ((argc 0)
        (argv (null-pointer)))
    (let ((app (gtk-application-new "try.window" :none)))
      (setf *global-app* app)
      (setf *do-not-quit* 3)
      (g-signal-connect app "activate" #'add-new-window)
      (let ((status (g-application-run app argc argv)))
        (g-object-unref (pointer app))
        status))))

;;; ===this allows me to interact with model using REPL=========================
;; (setf *do-not-quit* 3)
;; (setf *global-app*  (gtk-application-new "weeee" :none))
;; ==== we may not need this one === (g-application-register *global-app* nil)
;; (g-application-activate *global-app*)
;; (within-main-loop (add-new-window *global-app*))
;; use your REPL here and finally unref the memory
;; (g-object-unref (pointer *global-app*))


;; (load "/home/jacek/Programming/Pyrulis/Lisp/window.lisp")
;; (in-package :window)
