;;;; cairo-snake.lisp

(in-package #:cairo-snake)

(defparameter *global* nil)

;;; model -------------------------------------------------
(defstruct model
  (debug-data '() :type null)
  (eaten 0        :type integer)
  (food-items)
  (game-field 'move :type symbol)
  (grow-by 1)
  (heading 'heading-right)
  (height 400)
  (last-key 32)
  (scale 25)
  (snake '((6 . 7) (5 . 7)))
  (tick-interval 500)
  (seed 1)
  (width 600))

(defun initial-model ()
  (make-model
                                        ;:debug-data '()
   ;; :eaten 0
   :food-items '()
   ;; :game-field 'move
   ;; :grow-by 1
   ;; :heading 'heading-right
   ;; :height 400
   ;; :last-key 32
   ;; :scale 25
   ;; :snake '((6 . 7) (5 . 7))
   ;; :tick-interval 500
   ;; :seed 1
   ;; :width 600
   ))


(defun init-global-model ()
  (setf *global* (initial-model)))

(defun shrink (n)
  (if (> (1- n)
         0)
      (1- n)
      0))

(defun food-under-head (c model)
  (some 'identity (map 'list (lambda (x)
                               (equalp  x c))
                       (subseq (model-snake model) 0 1))))

(defun food-eaten (model)
  (members (model-food-items model)
           (subseq (model-snake model) 0 2)))

;;; member is already defined in lisp

(defun members (ee l)
  (some 'identity (map 'list (lambda (e) (member e l :test 'equal)) ee)))

(defun head-bit-snake (model)
  (labels
      ((hsm ()
         (car (model-snake model))))
    (some 'identity
          (map 'list
               (lambda (c) (equal c (hsm)))
               (subseq (model-snake model) 1)))))

;;; view --------------------------------------------------
;;; update ------------------------------------------------
;;; main --------------------------------------------------
(defun timer-fun (gm canvas)
  (format *o* "timer fun ~A ~A~%" gm canvas)
  (update-global-model 'tick)
  (not nil))

(defun draw-fun (gm canvas context)
  (format *o* "draw fun ~A ~A~%" canvas context))

(defun key-press-fun (gm canvas rkv)
  (format *o* "key press fun ~A ~A~%" canvas rkv)
  (update-global-model 'keypress)
  (gtk-widget-queue-draw canvas)
  (format *o* "key value ~A~%" (gdk-event-key-keyval rkv)))

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

      (g-timeout-add 1000
                     (lambda () (timer-fun global-model canvas))
                     :priority +g-priority-default+)

      (g-signal-connect canvas "draw"
                        (lambda (canvas context)
                          (draw-fun global-model canvas context)))

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
