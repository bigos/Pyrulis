;;;; cairo-snake.lisp

(in-package #:cairo-snake)

;; add
;; timer-fun
;; global-model
;; draw-fun
;; key-press-fun

(defun timer-fun (gm canvas)
  nil)

(defun draw-fun (gm canvas context)
  nil)

(defun key-press-fun (gm canvas rkv)
  nil)

(defparameter global-model T)

(defun main ()
  "Run the program"
  (within-main-loop
    (let ((win (gtk-window-new :toplevel))
          (canvas (gtk-drawing-area-new)))
      (setf (gtk-window-default-size win) (list 300 200))
      (gtk-container-add win canvas)

      (g-timeout-add 500 (timer-fun global-model canvas) :priority +g-priority-default+)

      ;; how do i use context here?
      (g-signal-connect canvas "draw"
                        (lambda (context)
                         (draw-fun global-model canvas context)))

      ;; another untested copy
      (g-signal-connect win "key-press"
                        (lambda (rkv)
                          (key-press-fun global-model canvas rkv)))

      (g-signal-connect win "destroy"
                        (lambda (widget)
                          (declare (ignore widget))
                          (leave-gtk-main)))

      (gtk-widget-show-all win))))
