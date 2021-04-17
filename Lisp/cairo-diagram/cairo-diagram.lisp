(declaim (optimize (speed 0) (safety 3) (debug 3)))

#| REPL use
(push #p "~/Programming/Pyrulis/Lisp/cairo-diagram/" asdf:*central-registry*)
(ql:quickload :cairo-diagram)
(in-package :cairo-diagram)
|#

(in-package #:cairo-diagram)

(defparameter *last-motion-notify* nil)
(defparameter *global* nil)
(defparameter *o* *standard-output*)

(defun init-global-model ()
  (setf *global* 0))

(defun draw-canvas (canvas context)
  (let* ((w (gtk-widget-get-allocated-width canvas))
         (h (gtk-widget-get-allocated-height canvas))
         (size (cons w h))
         (s 99999)

         (cr (pointer context)))

    ;; prevent cr being destroyed improperly
    (cairo-reference cr)

    (format *o* "canvas size is ~A --- ~A ~A === ~A~%" size w h s)
    (format *o* "pointer context ~A~%" cr)

    (cairo-set-source-rgb cr 0.6 0.9 0)
    (cairo-set-line-width cr 25)
    (cairo-set-line-cap cr :round)
    (cairo-set-line-join cr :round)

    ;; draw dots
    (cairo-set-source-rgb cr 0.4 0.6 0.1)
    (cairo-set-line-width cr 13)
    (loop for c in (list '(1 . 1) '(10 . 4) '(20 . 4))
          do (cairo-move-to cr (* 10 (car c)) (* 10 (cdr c)))
             (cairo-line-to cr (+ (* 10 (car c)) *global*) (+ (* 10 (cdr c)) *global*)))
    (cairo-stroke cr)


    ;; cleanup
    ;; cairo destroy must have matching cairo-reference
    (cairo-destroy cr)

    ;; continue propagation of the event handler
    +gdk-event-propagate+))

;;; ====================== view ================================================
(defun draw-fun (canvas context)
  (draw-canvas canvas context))

(defun key-press-fun (canvas rkv)
  (format *o* "key press fun ~A ~A~%" canvas rkv)
  (let ((kv (gdk-event-key-keyval rkv)))
    (format *o* "key value ~A~%" kv)))

(defun timer-fun (canvas)
  ;; (format *o* "AFTER timer fun ~A~%" gm)  ;problem here
  (setf *global* (+ *global* 3))
  (when (> *global* 100)
    (setf *global* 0))

  (gtk-widget-queue-draw canvas)
  +gdk-event-stop+)

(defun main ()
  "Run the program"
  (format *o* "boooo~%")
  (format t "entering main loop~%")

  (init-global-model)
  (sb-int:with-float-traps-masked (:divide-by-zero)
    (within-main-loop
      (let ((win (gtk-window-new :toplevel))
            (canvas (gtk-drawing-area-new)))
        (setf (gtk-window-default-size win) (list 300 200))
        (gtk-container-add win canvas)

        ;; signals
        (g-timeout-add 1000
                       (lambda () (timer-fun canvas))
                       :priority +g-priority-default+)

        (g-signal-connect canvas "draw"
                          (lambda (widget context)
                            (draw-fun widget context)))
        (g-signal-connect canvas "configure-event"
                          (lambda (widget event) (declare (ignore widget))
                            (format *o* "event data ~A~%" event)
                            +gdk-event-propagate+))
        (g-signal-connect canvas "motion-notify-event"
                          (lambda (widget event) (declare (ignore widget))
                            ;; (format *o* "mouse motion event data ~A~%" event)
                            (setf *last-motion-notify*
                                  (format nil "mouse motion event data ~A~%" event))
                            +gdk-event-propagate+))
        (g-signal-connect canvas "button-press-event"
                          (lambda (widget event) (declare (ignore widget))
                            (format *o* "recorded event ~A~%" *last-motion-notify*)
                            (format *o* "event data ~A~%" event)
                            +gdk-event-propagate+))
        (g-signal-connect canvas "button-release-event"
                          (lambda (widget event) (declare (ignore widget))
                            (format *o* "event data ~A~%" event)
                            +gdk-event-propagate+))
        ;; following has some information in the state of the event
        (gtk-widget-add-events canvas '(:all-events-mask))

        (g-signal-connect win "key-press-event"
                          (lambda (widget rkv)
                            (key-press-fun widget rkv)))
        (g-signal-connect win "key-release-event"
                          (lambda (widget rkv)
                            (key-press-fun widget rkv)))
        (g-signal-connect win "destroy"
                          (lambda (widget)
                            (declare (ignore widget))
                            (leave-gtk-main)))

        (gtk-widget-show-all win)))
    (join-gtk-main)
    (format *o* "~&after the main loop~%")))
