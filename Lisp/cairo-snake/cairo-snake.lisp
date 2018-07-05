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
  (tick-counter 0)
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
   ;; :snake nil
   ;; :tick-interval 500
   ;; :seed 1
   ;; :width 600
   ))


(defun init-global-model ()
  (setf *global* (initial-model))
  (setf (model-snake *global*) '((6 . 7) (5 . 7))))

(defun shrink (n)
  (let ((res (1- n)))
    (if (> res 0)
        res
        0)))

(defun food-under-head (c model)
  (some 'identity (map 'list (lambda (x)
                               (equalp  x c))
                       (take 1 (model-snake model)))))

(defun food-eaten (model)
  (when
      model
    (members (model-food-items model)
             (take 1 (model-snake model)))))

;;; member is already defined in lisp

(defun members (ee l)
  (some 'identity (map 'list (lambda (e) (member e l :test 'equal)) ee)))

(defun head-bit-snake (model)
  ;; TODO: fix me

  (let ((hsm (car (model-snake model)))
        (t1 (cdr (model-snake model))))
    (format t "hsm is ~A~%~A~%" hsm t1)
    (some 'identity
          (map 'list
               (lambda (c) (equal c hsm))
               t1))))

(defun take (n l)
  (if (> (length l) n)
      (subseq l 0 n)
      l))

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

(defun draw-canvas (canvas model context)
  (let* ((w (gtk-widget-get-allocated-width canvas))
         (h (gtk-widget-get-allocated-height canvas))
         (size (cons w h))
         (s (floor (/ (min h w) 15)))
         (cr (pointer context)))
    ;; TODO: finish the source business
    ;; http://www.crategus.com/books/cl-gtk/gtk-tutorial_2.html

    (format *o* "canvas size is ~A --- ~A ~A === ~A~%" size w h s)

    (cairo-set-source-rgb cr 0.6 0.9 0)
    (cairo-set-line-width cr 25)
    (cairo-set-line-cap cr :round)
    (cairo-set-line-join cr :round)

    ;; draw snakes food
    (cairo-set-source-rgb cr 0.4 0.6 0.1)
    (cairo-set-line-width cr 13)
    (loop for c in (model-food-items model)
          do (cairo-move-to cr (* 10 (car c)) (* 10 (cdr c)))
             (cairo-line-to cr (* 10 (car c)) (* 10 (cdr c))))
    (cairo-stroke cr)

    ;; draw snake
    (case (model-game-field model)
      (move (cairo-set-source-rgb cr 0 0.5 1))
      (collision (cairo-set-source-rgb cr 1 1 0.5))
      (otherwise (cairo-set-source-rgb cr 0.4 0.4 0.4)))
    (cairo-set-line-width cr 5)
    (cairo-move-to cr
                   (* 10 (car (car (model-snake model))))
                   (* 10 (cdr (car (model-snake model)))))
    (loop for c in (model-snake model)
          do (cairo-line-to cr
                            (* 10 (car c))
                            (* 10 (cdr c))))
    (cairo-stroke cr)

    ;; cleanup
    (cairo-destroy cr)
    +gdk-event-propagate+))

;;; update ------------------------------------------------

(defun random-coord (size seedn)
  (declare (ignore seedn))
  (loop for x from 1 to 3
        collect (cons (1+ (random (car size) ))
                      (1+ (random (cdr size) )))))

(defun cook (model)
  (format *o* "going to cook ~A~%" model)
  (if (food-eaten model)
      (progn
        (format *o* "going to cook in THEN~%")
        (setf
         (model-game-field model) (detect-collision model)
         (model-grow-by model) (1+ (model-grow-by model))
         (model-food-items model) (remove-if (lambda (c) (not (food-under-head c model))) (model-food-items model))
         (model-debug-data model) (format nil "debugging")
         (model-eaten model) (1+ (model-eaten model))))
      (progn
        (format *o* "going to cook in ELSE~%")
        (setf
         (model-game-field model) (detect-collision model)
         (model-grow-by model) (shrink (model-grow-by model))
         (model-debug-data model) (format nil "-"))))
  (format *o* "after cooking ~A~%" model)
  model)

(defun update-global-model (arg model)
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
                                  (model-tick-counter m) (1+ (model-tick-counter m))
                                  (model-snake m) (move-snake model (model-heading model)))))
      (progn
        (format t "~&going to update fields~%")
        (update-tick-fields model)))))

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
                             (model-snake m) (move-snake model (model-heading model)))))
      (update-fields old-model))))

(defun update-game-field (key-event model kk)
  (if key-event
      (cond
        ((eq (model-game-field model) 'pause) 'move)
        ((eq (model-game-field model) 'move) (if (eq kk 32)
                                                 'pause
                                                 (model-game-field model)))
        (T (model-game-field model)))
      (model-game-field model)))

(defun snake-grower (growth snakecc)
  (cond ((>  growth 0) snakecc)
        ((eq growth 0) (butlast snakecc))
        ((<  growth 0) (butlast (butlast snakecc)))))

(defun move-snake (model headingv)
  ;; finish me
  (format *o* "~&going to move snakw~%")
  (if (or (eq (model-game-field model) 'pause)
          (eq (model-game-field model) 'collision))
      (progn
        (format *o* "paused~%")
        (model-snake model))
      (progn
        (format *o* "moving snake~%")
        (move-snake2 model headingv))))

(defun move-snake2 (model headingv)
  (let* ((snake1 (model-snake model))
         (growth (model-grow-by model))
         (uhs (car snake1))
         (sgs (snake-grower growth snake1)))
    (case headingv
      (heading-left  (cons (cons (1- (car uhs)) (cdr uhs))      sgs))
      (heading-up    (cons (cons (car uhs)      (1- (cdr uhs))) sgs))
      (heading-right (cons (cons (1+ (car uhs)) (cdr uhs))      sgs))
      (heading-down  (cons (cons (car uhs)      (1+ (cdr uhs))) sgs))
      (none sgs))))

;;; main --------------------------------------------------
(defun timer-fun (gm canvas)
  (format *o* "timer fun ~A ~A~%" gm canvas)
  (update-global-model 'tick gm)
  (gtk-widget-queue-draw canvas)
  ;; (format *o* "AFTER timer fun ~A~%" gm)  ;problem here
  (not nil))

(defun draw-fun (gm canvas context)
  (let ((model gm))
      (draw-canvas canvas model context)))

(defun key-press-fun (gm canvas rkv)
  (format *o* "key press fun ~A ~A~%" canvas rkv)
  (let ((kv (gdk-event-key-keyval rkv)))
    (update-global-model kv *global*)
    (gtk-widget-queue-draw canvas)
    (format *o* "key value ~A ~A~%" kv gm)))

(defparameter global-model nil)
(defparameter *o* *standard-output*)

(defun main ()
  "Run the program"
  (format *o* "boooo~%")
  (format t "entering main loop~%")
  (init-global-model)
  (setf global-model *global*)
  (format *o* "global model is ~A~%" global-model)
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
