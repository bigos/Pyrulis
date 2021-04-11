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

(defun key-press-fun (gm canvas rkv)
  (format *o* "key press fun ~A ~A~%" canvas rkv)
  (let ((kv (gdk-event-key-keyval rkv)))

    (format *o* "key value ~A ~A~%" kv gm)))

(defun main ()
  "Run the program"
  (format *o* "boooo~%")
  (format t "entering main loop~%")
  (init-global-model)
  (format *o* "global model is ~A~%" *global*)

  (sb-int:with-float-traps-masked (:divide-by-zero)
    (within-main-loop
     (let ((win (gtk-window-new :toplevel))
           (canvas (gtk-drawing-area-new))
           )

       (setf (gtk-window-default-size win) (list 300 200))
       (gtk-container-add win canvas)

       ;; (g-timeout-add 1000
       ;;                (lambda () (timer-fun global-model canvas))
       ;;                :priority +g-priority-default+)

       ;; (g-signal-connect canvas "draw"
       ;;                   (lambda (canvas context)
       ;;                     (draw-fun global-model canvas context)))

       (g-signal-connect win "key-press-event"
                         (lambda (win rkv)
                           (key-press-fun global-model win rkv)))

       (g-signal-connect win "destroy"
                         (lambda (win)
                           (declare (ignore win))
                           (leave-gtk-main)))

       (gtk-widget-show-all win)))
    (join-gtk-main)
    (format *o* "~&after the main loop~%")))
