(declaim (optimize (speed 0) (safety 3) (debug 3)))

#| REPL use
(push #p "~/Programming/Pyrulis/Lisp/cairo-diagram/" asdf:*central-registry*)
(ql:quickload :cairo-diagram)
(in-package :cairo-diagram)
|#

(in-package #:cairo-diagram)

(defparameter *global* nil)
(defparameter *o* *standard-output*)

(defun init-global-model ()
  (setf *global* nil))

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
    (loop for c in (list '(0 . 0) '(10 . 1) '(20 . 2))
          do (cairo-move-to cr (* 10 (car c)) (* 10 (cdr c)))
             (cairo-line-to cr (* 10 (car c)) (* 10 (cdr c))))
    (cairo-stroke cr)


    ;; cleanup
    ;; cairo destroy must have matching cairo-reference
    (cairo-destroy cr)

    ;; continue propagation of the event handler
    +gdk-event-propagate+))

(defun draw-fun (canvas context)
  (draw-canvas canvas context))

(defun key-press-fun (canvas rkv)
  (format *o* "key press fun ~A ~A~%" canvas rkv)
  (let ((kv (gdk-event-key-keyval rkv)))

    (format *o* "key value ~A~%" kv)))


(defun timer-fun (canvas)
  ;; (format *o* "AFTER timer fun ~A~%" gm)  ;problem here
  (not +gdk-event-propagate+))

(defun main ()
  "Run the program"
  (format *o* "boooo~%")
  (format t "entering main loop~%")

  (sb-int:with-float-traps-masked (:divide-by-zero)
    (within-main-loop
     (let ((win (gtk-window-new :toplevel))
           (canvas (gtk-drawing-area-new))
           )

       (setf (gtk-window-default-size win) (list 300 200))
       (gtk-container-add win canvas)

       (g-timeout-add 1000
                      (lambda () (timer-fun canvas))
                      :priority +g-priority-default+)

       (g-signal-connect canvas "draw"
                         (lambda (canvas context)
                           (draw-fun canvas context)))

       (g-signal-connect win "key-press-event"
                         (lambda (win rkv)
                           (key-press-fun win rkv)))

       (g-signal-connect win "destroy"
                         (lambda (win)
                           (declare (ignore win))
                           (leave-gtk-main)))

       (gtk-widget-show-all win)))
    (join-gtk-main)
    (format *o* "~&after the main loop~%")))
