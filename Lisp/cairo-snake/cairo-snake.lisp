;;;; cairo-snake.lisp

(in-package #:cairo-snake)

;; add
;; timer-fun
;; global-model
;; draw-fun
;; key-press-fun

(defun timer-fun ()
  (format *o* "timer fun~%" )
  (not nil))

(defun draw-fun (gm canvas context)
  (format *o* "draw fun ~A ~A~%" canvas context)
  )

(defun key-press-fun (gm canvas rkv)
  (format *o* "key press fun ~A ~A~%" canvas rkv)
  (format *o* "key value ~A~%" (gdk-event-key-keyval rkv))
  )

(defparameter global-model T)
(defparameter *o* *standard-output*)

(defun main ()
  "Run the program"
  (format *o* "boooo~%")
  (format t "entering main loop~%")
  (within-main-loop
    (let ((win (gtk-window-new :toplevel))
          (canvas (gtk-drawing-area-new)))
      (setf (gtk-window-default-size win) (list 300 200))
      (gtk-container-add win canvas)

      (g-timeout-add 1000 #'timer-fun
                     :priority +g-priority-default+)

      ;; how do i use context here?
      (g-signal-connect canvas "draw"
                        (lambda (canvas context)
                          (draw-fun global-model canvas context)))

      ;; another untested copy
      (g-signal-connect win "key-press-event"
                        (lambda (win rkv)
                          (key-press-fun global-model win rkv)))

      (g-signal-connect win "destroy"
                        (lambda (win)
                          (declare (ignore win))
                          (format *o* "~&going to leave")
                          (leave-gtk-main)))

      (gtk-widget-show-all win)))
  (format t "~&after the main loop~%"))
