(declaim (optimize (speed 0) (safety 3) (debug 3)))

#| REPL use
(push #p "~/Programming/Pyrulis/Lisp/cairo-diagram/" asdf:*central-registry*)
(ql:quickload :cairo-diagram)
(in-package :cairo-diagram)
|#

(in-package #:cairo-diagram)

(defparameter *last-motion-notify* nil)
(defparameter *global-model* nil)
(defparameter *o* *standard-output*)

(defstruct global-model
  (c 999 :type integer)
  (nodes nil)
  (links nil))

(defstruct node
  (label "" :type string)
  (coord-x)
  (coord-y))

(defstruct link
  (label "" :type string)
  (source)
  (target))

(defun init-global-model ()
  (setf *global-model* (make-global-model :c 0))
  (push (make-node :label "a" :coord-x 10 :coord-y 10)   (global-model-nodes *global-model*))
  (push (make-node :label "b" :coord-x 100 :coord-y 70) (global-model-nodes *global-model*))
  (push (make-link :label "a2b" :source "a" :target "b") (global-model-links *global-model*)))

;;; ====================== view ================================================

;;; canvas======================================================================
(defun draw-canvas (canvas context)
  (let* ((w (gtk-widget-get-allocated-width canvas))
         (h (gtk-widget-get-allocated-height canvas))
         (size (cons w h))
         (s 99999)
         (cr (pointer context)))
    ;; prevent cr being destroyed improperly
    (cairo-reference cr)

    (draw-canvas-lines cr)
    (draw-canvas-diagram cr)


    ;; cleanup
    ;; cairo destroy must have matching cairo-reference
    (cairo-destroy cr)

    ;; continue propagation of the event handler
    +gdk-event-propagate+))

(defun draw-canvas-diagram (cr)
  ;; draw nodes
  (cairo-set-source-rgb cr 0.99 0.1 0.1)
  (cairo-set-line-width cr 5)
  (loop for n in (global-model-nodes *global-model*) do
    (let ((x (node-coord-x n))
          (y (node-coord-y n)))
      (cairo-move-to cr x y)
      (cairo-line-to cr (+ x 5) (+ y 5))))
  (cairo-stroke cr)

  ;; draw links
  (cairo-set-source-rgb cr 0.1 0.1 0.99)
  (cairo-set-line-width cr 2)
  (loop for l in (global-model-links *global-model*) do
    (let ((sl (car (loop for nx in (global-model-nodes *global-model*)
                         when (equalp (link-source l) (node-label nx))
                           collect nx)))
          (tl (car (loop for nx in (global-model-nodes *global-model*)
                         when (equalp (link-target l) (node-label nx))
                           collect nx)) )
          (ll (link-label  l)))
      (let ((slx (node-coord-x sl))
            (sly (node-coord-y sl))
            (tlx (node-coord-x tl))
            (tly (node-coord-y tl)))
        (cairo-move-to cr slx sly)
        (cairo-line-to cr tlx tly))))
  (cairo-stroke cr))

(defun draw-canvas-lines (cr)
  (cairo-set-source-rgb cr 0.6 0.9 0)
  (cairo-set-line-width cr 25)
  (cairo-set-line-cap cr :round)
  (cairo-set-line-join cr :round)

  ;; draw dots
  (cairo-set-source-rgb cr 0.4 0.6 0.1)
  (cairo-set-line-width cr 13)
  (loop for c in (list '(1 . 1) '(10 . 4) '(20 . 7))
        do (cairo-move-to cr
                          (* 10 (car c))
                          (* 10 (cdr c)))
           (cairo-line-to cr
                          (+ (* 10 (car c)) (global-model-c *global-model*))
                          (+ (* 10 (cdr c)) (global-model-c *global-model*))))
  (cairo-stroke cr))

(defun draw-fun (canvas context)
  (draw-canvas canvas context))

;;; event handling==============================================================
(defun canvas-event-fun (widget event)
  (declare (ignore widget))
  (typecase event
    (gdk-event-configure (format *o* "c"))
    (gdk-event-motion (format *o* "-"))
    (gdk-event-button (if (equal (gdk-event-button-type event) :button-release)  ; mouse button
                          (format *o* "~&~A ~A~%"
                                  (gdk-event-button-type event)
                                  (gdk-event-button-button event))
                          (format *o* "~&EEE b~A ~A~%" (gdk-event-button-type event) event)))
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
      ((:key-press)   (format *o* "~&key press event ~A ~A ~A~A~%" et str sta event))
      ((:key-release) (format *o* "~&key release event ~A ~%" str))
      (otherwise (error "unknown key event type ~A" et)))))

(defun timer-fun (canvas)
  ;; do something with the model after timeout
  (setf (global-model-c *global-model*) (+ (global-model-c *global-model*) 3))
  (when (> (global-model-c *global-model*) 100)
    (setf (global-model-c *global-model*) 0))

  ;; attempt to redraw canvas
  (gtk-widget-queue-draw canvas)
  +gdk-event-stop+)

;;; main========================================================================
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
                              "key-release-event"
                              "focus-in-event")
              do (g-signal-connect win ev #'win-event-fun))

        (g-signal-connect win "destroy"
                          (lambda (widget)
                            (declare (ignore widget))
                            (leave-gtk-main)))

        (gtk-widget-show-all win)))
    (join-gtk-main)
    (format *o* "~&after the main loop~%")))
