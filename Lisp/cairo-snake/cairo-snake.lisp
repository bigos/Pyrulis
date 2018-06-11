;;;; cairo-snake.lisp

(in-package #:cairo-snake)

;; add
;; timer-fun
;; global-model
;; draw-fun
;; key-press-fun

(defun timer-fun (gm canvas)
  T)

(defun draw-fun (gm canvas context)
  T)

(defun key-press-fun (gm canvas rkv)

  T)

(defparameter global-model T)

(defun main ()
  "Run the program"
  (format t "entering main loop~%")
  (within-main-loop
    (let ((win (gtk-window-new :toplevel))
          (canvas (gtk-drawing-area-new)))
      (setf (gtk-window-default-size win) (list 300 200))
      (gtk-container-add win canvas)

      ;; (g-timeout-add 500 (timer-fun global-model canvas) :priority +g-priority-default+)

      ;; how do i use context here?
      (g-signal-connect canvas "draw"
                        (lambda (canvas context)
                          (draw-fun global-model canvas (pointer context))))

      ;; another untested copy
      (g-signal-connect win "key-press-event"
                        (lambda (win rkv)
                          (key-press-fun global-model win rkv)))

      (g-signal-connect win "destroy"
                        (lambda (win)
                          (declare (ignore win))
                          (leave-gtk-main)))

      (gtk-widget-show-all win)))
  (format t "~&after the main loop~%"))
