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
<<<<<<< HEAD
  (some 'identity
        (map 'list
             (lambda (x) (equalp  x c))
             (subseq (model-snake  *global*) 0 2))))
=======
  (some 'identity (map 'list (lambda (x)
                               (equalp  x c))
                       (subseq (model-snake model) 0 1))))

(defun food-eaten (model)
  (some 'identity
        (loop for fi in (model-food-items model)
              collect (car (member fi
                                   (subseq (model-snake model) 0 2)
                                   :test 'equal)))))
;;; note member and members in Haskell version
>>>>>>> 820187ca78069e0da3c29ff6d90117222ec31cad

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
