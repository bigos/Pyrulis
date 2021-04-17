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

    (format *o* "~&canvas size is ~A --- ~A ~A === ~A~%" size w h s)
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

(defun canvas-event-fun (widget event)
  (declare (ignore widget))
  (typecase event
    (gdk-event-configure (format *o* "c"))
    (gdk-event-motion (format *o* "-"))
    (gdk-event-button (format *o* "b"))
    (t (error "not implemented ~A~%" (type-of event))))
  +gdk-event-propagate+)

(defun win-event-fun (widget event)
  (declare (ignore widget))
  (typecase event
    (gdk-event-key (key-event-fun event))
    (t (error "not implemented ~A~%" (type-of event)))))

(defun key-event-fun (event)
  (let ((et  (gdk-event-key-type   event))
        (str (gdk-event-key-string event))
        (sta (gdk-event-key-state  event)))
    (case et
      ((:key-press)   (format *o* "key press event ~A ~A ~A~%" et str sta))
      ((:key-release) (format *o* "key release event ~A ~%" str))
      (otherwise (error "unknown key event type ~A" et)))))

(defun timer-fun (canvas)
  ;; (format *o* "AFTER timer fun ~A~%" gm)  ;problem here
  (setf *global* (+ *global* 3))
  (when (> *global* 100)
    (setf *global* 0))

  (gtk-widget-queue-draw canvas)
  +gdk-event-stop+)

(defun main ()
  "Run the program"
  (init-global-model)
  (sb-int:with-float-traps-masked (:divide-by-zero)
    (within-main-loop
      (let ((win (gtk-window-new :toplevel))
            (canvas (gtk-drawing-area-new)))
        (setf (gtk-window-default-size win) (list 300 200))
        (gtk-container-add win canvas)

        (g-timeout-add 1000
                       (lambda () (timer-fun canvas))
                       :priority +g-priority-default+)

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

        ;; window signals
        (loop for ev in (list "key-press-event"
                              "key-release-event")
              do (g-signal-connect win ev #'win-event-fun))

        (g-signal-connect win "destroy"
                          (lambda (widget)
                            (declare (ignore widget))
                            (leave-gtk-main)))

        (gtk-widget-show-all win)))
    (join-gtk-main)
    (format *o* "~&after the main loop~%")))
