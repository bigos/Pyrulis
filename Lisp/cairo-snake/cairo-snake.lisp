;;;; cairo-snake.lisp

(declaim (optimize (speed 0) (safety 3) (debug 3)))

(in-package #:cairo-snake)

(defparameter *global* nil)

;;; model -------------------------------------------------
(defstruct model
  (debug-data)
  (eaten 0        :type integer)
  (food-items)
  (game-field 'move :type symbol)
  (grow-by 1)
  (heading 'heading-right)
  (height 400)
  (last-key 32)
  (scale 25)
  (snake)
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
   :snake '((6 . 7) (5 . 7))
   ;; :tick-interval 500
   ;; :seed 1
   ;; :width 600
   ))


(defun init-global-model ()
  (setf *global* (initial-model)))

(defun shrink (n)
  (let ((res (1- n)))
    (if (> res 0)
        res
        0)))

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

(defun head-hit-wall (x)
  nil)                                ;finish me

(defun detect-collision (model)
  (if (or (head-hit-wall model)
          (head-bit-snake model))
      'collision
      (model-game-field model)))

;;; helpers -----------------------------------------------
(defun key-to-heading (lk)
  (cond
    ((eq lk 65361) 'heading-left)
    ((eq lk 65362) 'heading-up)
    ((eq lk 65363) 'heading-right)
    ((eq lk 65364) 'heading-down)
    (T 'none)))
;;; view --------------------------------------------------

(defun draw-canvas (canvas model)
  (format *o* "drawing~%" model)
  (finish-me))

;;; update ------------------------------------------------

(defun random-coord (size seedn)
  (declare (ignore seedn))
  (loop for x from 1 to 1
        collect (cons (random size )
                      (random size ))))

(defun cook (model)
  (if (food-eaten model)
      (setf
       (model-game-field model) (detect-collision model)
       (model-grow-by model) (1+ (model-grow-by model))
       (model-food-items model) (remove-if (lambda (c) (not (food-under-head c model))) (model-food-items model))
       (model-debug-data model) (format nil "debugging")
       (model-eaten model) (1+ (model-eaten model)))
      (setf
       (model-game-field model) (detect-collision model)
       (model-grow-by model) (shrink (model-grow-by model))
       (model-debug-data model) (format nil "-")))
  model)

(defun update-global-model (arg model)
  (format *o* "the ARG is ~a~%" arg)
  (if (eq arg 'tick)
      (update-global-model-tick model)
      (update-global-model-keypress arg model)))

(defun update-global-model-tick (raw-model)
  (format *o* "doing tick~%")
  (let ((model (cook raw-model)))
    (labels
        ((more-food (model1) (if (equal (model-food-items model1) nil)
                                 (random-coord (cons 13 13) (model-seed model))
                                 (model-food-items model1)))
         (update-tick-fields (m) (setf
                                  (model-game-field m) (update-game-field nil model (model-last-key model))
                                  (model-food-items m) (more-food model)
                                  (model-snake m) (move-snake model (model-heading model)))))
      (update-tick-fields model))))

(defun update-global-model-keypress (kv old-model)
  (format *o* "doing keypress~%")
  (let ((model (cook old-model)))
    (labels
        ((new-kv () kv)
         (new-heading () (if (eq (new-kv) 'none) (model-heading model) (new-kv)))
         (update-fields (m) (setf
                             (model-seed m) (1+ (model-seed m))
                             (model-last-key m) (new-kv)
                             (model-heading m) (new-heading)
                             (model-game-field m) (update-game-field T model kv)
                             (model-snake m) (move-snake model (heading model)))))
      (update-fields old-model))))

(defun update-game-field (key-event model kk)
  ;; finish me
  (model-game-field model))

(defun snake-grower (growth snakecc)
  ;; finish me
  nil)

(defun move-snake (model headingv)
  ;; finish me
  nil)


;;; main --------------------------------------------------
(defun timer-fun (gm canvas)
  (format *o* "timer fun ~A ~A~%" gm canvas)
  (update-global-model 'tick *global*)
  (not nil))

(defun draw-fun (gm canvas context)
  (format *o* "draw fun ~A ~A~%" canvas context))

(defun key-press-fun (gm canvas rkv)
  (format *o* "key press fun ~A ~A~%" canvas rkv)
  (let ((kv (gdk-event-key-keyval rkv)))
    (update-global-model kv *global*)
    (gtk-widget-queue-draw canvas)
    (format *o* "key value ~A ~A~%" kv *global*)))

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
