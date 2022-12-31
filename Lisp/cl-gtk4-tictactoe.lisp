(declaim (optimize (speed 0) (safety 2) (debug 3)))

(cl:in-package "CL-USER")

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(cl-gtk4
                  cl-gdk4
                  cl-glib
                  cl-cairo2
                  serapeum
                  defclass-std)))

(defpackage #:cairo-gobject
  (:use)
  (:export #:*ns*))

(in-package #:cairo-gobject)

(gir-wrapper:define-gir-namespace "cairo")

(cl:in-package "CL-USER") ; make sure you come back to cl-user because the previous package does not use it

(defpackage #:cl-gtk4-tictactoe ; ----------------------------------------------
  (:use :cl #:gtk4)
  (:import-from :defclass-std
   :defclass/std)
  (:import-from :serapeum
   :~>) )

;; (load "~/Programming/Pyrulis/Lisp/cl-gtk4-tictactoe.lisp")
(in-package #:cl-gtk4-tictactoe)

;;; ============================================================================

(cffi:defcstruct gdk-rgba
  (red :double)
  (green :double)
  (blue :double)
  (alpha :double))

(defmacro with-gdk-rgba ((pointer color) &body body)
  `(cffi:with-foreign-object (,pointer '(:struct gdk-rgba))
     (let ((,pointer (make-instance 'gir::struct-instance
                                    :class (gir:nget gdk::*ns* "RGBA")
                                    :this ,pointer)))
       (gdk:rgba-parse ,pointer ,color)
       ,@body)))

;;; ============================================================================
;;; drawing ====================================================================

(defun square-at (x y)
  (let ((size 50))
    (cairo:rectangle x y size size)
    (cairo:fill-path)))

(defun square-centered-at (x y size)
  (cairo:rectangle (- x (/ size 2))
                   (- y (/ size 2))
                   size size)
  (cairo:fill-path))

(defun draw-func (area cr width height model)
  (declare (ignore area))

  (warn "drawing ~S ~S === ~S ~S" width height (ui-width model) (ui-height model))

  ;; keep the existing drawing and continue drawing past it using the procedural method
  (let ((w (coerce (the (signed-byte 32) width)  'single-float))
        (h (coerce (the (signed-byte 32) height) 'single-float)))
    (let ((hw (/ w 2))
          (hh (/ h 2)))
      (cairo:arc
       (/ w 2.0)
       (/ h 2.0)
       (/ (min w h) 2.0)
       0.0
       (* 2.0 (coerce pi 'single-float)))

      (with-gdk-rgba (color "#FF8844FF")
        (gdk:cairo-set-source-rgba cr color))
      (cairo:fill-path)

      (cairo:move-to 0.0 0.0)
      (cairo:line-to w h)
      (with-gdk-rgba (color "#227722FF")
        (gdk:cairo-set-source-rgba cr color))
      (cairo:stroke)

      (let* ((size (/ (min w h) 4.5))
             (dist (+ size (* size 0.05))))

        ;; grid background
        (with-gdk-rgba (color "#777777CC")
          (gdk:cairo-set-source-rgba cr color))
        (square-centered-at hw hh (+ (* size 3) (* size 0.20)))

        ;; grid
        (with-gdk-rgba (color "#FFFFFFCC")
          (gdk:cairo-set-source-rgba cr color))
        (square-centered-at (- hw dist) (- hh dist) size)
        (square-centered-at (- hw dist) hh size)
        (square-centered-at (- hw dist) (+ hh dist) size)

        (square-centered-at hw (- hh dist) size)
        (square-centered-at hw hh size)
        (square-centered-at hw (+ hh dist) size)

        (square-centered-at (+ hw dist) (- hh dist) size)
        (square-centered-at (+ hw dist) hh size)
        (square-centered-at (+ hw dist) (+ hh dist) size)

        ;; top bar
        (with-gdk-rgba (color "#BBBBBBCC")
          (gdk:cairo-set-source-rgba cr color))

        (cairo:rectangle (- hw (* size 2))
                         (- hh (* size 2.3))
                         (* size 4)
                         (* size 0.67))
        (cairo:fill-path)

        ;; bottom bar
        (with-gdk-rgba (color "#FFFFBBCC")
          (gdk:cairo-set-source-rgba cr color))
        (cairo:rectangle (- hw (* size 2))
                         (+ hh (* size 1.62))
                         (* size 4)
                         (* size 0.67))
        (cairo:fill-path)

        ;; help area
        (with-gdk-rgba (color "#88FFFFAA")
          (gdk:cairo-set-source-rgba cr color))
        (cairo:rectangle (- hw (* size 2) 10)
                         (- hh (* size 2))
                         (+ (* size 4) (* 2 10))
                         (* size 4))
        (cairo:fill-path))))

  ;; procedural method part
  (let ((size (/ (min (ui-width model) (ui-height model))
                 4.5)))
    (loop for cell-name in '(c7 c4 c1
                             c8 c5 c2
                             c9 c6 c3)
          for redval in '(200 180 160
                          140 120 100
                          80  60  40)
          do (let* ((gc (slot-value (grid model) cell-name))
                    (cc (car (coords gc))))
               (format t "cell coord ~S ~S    ~S ~S~%" cell-name cc (mouse-x model) (mouse-y model))
               (with-gdk-rgba (color (format nil "#~2,'0X~2,'0X~2,'0X~2,'0X" redval 200 230 255))
                 (gdk:cairo-set-source-rgba cr color)
                 (square-centered-at (car cc) (cdr cc) size)
                 (cairo:fill-path)))))

  (progn
    (format t "mouse coord ~S ~S~%" (mouse-x model) (mouse-y model))
    (when (mouse-x model)
      (cairo:rectangle (mouse-x model)
                       (mouse-y model)
                       25
                       25)))

  (with-gdk-rgba (color "#FFFFBBFF")
    (gdk:cairo-set-source-rgba cr color))
  (cairo:fill-path)

  (format t "mouse state ~S ~S~%" (mouse-x model) (mouse-y model))
  )

(cffi:defcallback %draw-func :void ((area :pointer)
                                    (cr :pointer)
                                    (width :int)
                                    (height :int)
                                    (data :pointer))
                  (declare (ignore data))
                  (let ((cairo:*context* (make-instance 'cairo:context
                                                        :pointer cr
                                                        :width width
                                                        :height height
                                                        :pixel-based-p nil)))
                    (draw-func (make-instance 'gir::object-instance
                                              :class (gir:nget gtk:*ns* "DrawingArea")
                                              :this area)
                               (make-instance 'gir::struct-instance
                                              :class (gir:nget cairo-gobject:*ns* "Context")
                                              :this cr)
                               width height *model*)))

;;; ============================================================================
;;; keys =======================================================================

(defun check-key (key-val key-code key-modifiers)
  (declare (ignore key-code))
  (let ((enterable (< (integer-length key-val) 16)))
    (format t "~a ~S ~S~%"
            (when enterable
              (code-char key-val))
            (gdk4:keyval-name key-val)
            (modifiers key-modifiers))))

;; https://gitlab.gnome.org/GNOME/gtk/-/blob/main/gdk/gdkkeysyms.h
(defun modifiers (modifiers)
  (let ((names '(:shift :lock :ctrl :alt "4" "5" "6" :gr :mb1 :mb2 :mb3 "11" "12"
                 "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24"
                 "25" :win)))
    (loop for x = 0 then (1+ x)
          for n in names
          when (and (plusp (ldb (byte 1 x) modifiers))
                    (typep n 'keyword))
            collect n)))

;;; ============================================================================
;;; TODO Add more code here.

(defmethod print-object ((obj standard-object) stream)
  (print-unreadable-object (obj stream :type t)
    (format stream "~S"
            (loop for sl in (sb-mop:compute-slots (class-of obj))
                  collect (list
                           (sb-mop:slot-definition-name sl)
                           (slot-value obj (sb-mop:slot-definition-name sl)))))))

;;; ============================================================================

(defclass/std grid-cell ()
  ((state)
   (mouse)
   (coords)))

(defun centered-at (x y size)
  "Get coordinates of square of SIZE centred at X Y."
  (declare (ignore size))
  (let ((tlx x)
        (tly y))

    (cons (cons tlx
                tly)
          (cons :Z :Z))))

;;; grid cells are numbered after the keys on the numeric keypad with 1 being
;; bottom left and 9 being top right
(defclass/std grid ()
  ((c1 :std (make-instance 'grid-cell))
   (c2 :std (make-instance 'grid-cell))
   (c3 :std (make-instance 'grid-cell))
   (c4 :std (make-instance 'grid-cell))
   (c5 :std (make-instance 'grid-cell))
   (c6 :std (make-instance 'grid-cell))
   (c7 :std (make-instance 'grid-cell))
   (c8 :std (make-instance 'grid-cell))
   (c9 :std (make-instance 'grid-cell))))

(defmethod place-ox ((grid grid) (cell symbol) (ox symbol))
  (let ((my-ox (ecase ox (:o ox) (:x ox))))
    (if (member cell '(c1 c2 c3 c4 c5 c6 c7 c8 c9))
        (let ((grid-cell (slot-value grid cell)))
          (setf (state grid-cell)  my-ox))
        (error "Cell ~s is not valid" cell))))

(defun get-grid-cells% (grid set)
  (loop for c in set
        collect
        (state
         (slot-value grid c))))

(defmethod get-rows ((grid grid) (cell symbol))
  (get-grid-cells% grid (ecase cell
                         (c1 '(c1 c2 c3))
                         (c4 '(c4 c5 c6))
                         (c7 '(c7 c8 c9)))))

(defmethod get-columns ((grid grid) (cell symbol))
  (get-grid-cells% grid (ecase cell
                         (c7 '(c7 c4 c1))
                         (c8 '(c8 c5 c2))
                         (c9 '(c9 c6 c3)))))

(defmethod get-diagonals ((grid grid) (cell symbol))
  (get-grid-cells% grid (ecase cell
                         (c7 '(c7 c5 c3))
                         (c9 '(c9 c5 c1)))))

(defmethod adjust-coordinates ((model model) (grid grid))
  (warn "finish adjust-coordinates")
  (let ((w (ui-width model))
        (h (ui-height model)))
    (let* ((hw (/ w 2))
           (hh (/ h 2))
           (size (/ (min w h) 4.5))
           (dist (+ size (* size 0.05)))
           (cell-names '(c7 c4 c1
                         c8 c5 c2
                         c9 c6 c3)))
      (let ((cell-coords (list
                          (centered-at (- hw dist) (- hh dist) size)
                          (centered-at (- hw dist) hh          size)
                          (centered-at (- hw dist) (+ hh dist) size)

                          (centered-at hw (- hh dist) size)
                          (centered-at hw hh          size)
                          (centered-at hw (+ hh dist) size)

                          (centered-at (+ hw dist) (- hh dist) size)
                          (centered-at (+ hw dist) hh          size)
                          (centered-at (+ hw dist) (+ hh dist) size)
                          )))
        (loop for cn in cell-names
              for cc in cell-coords
              do
                 (let ((gc (slot-value grid cn)))
                   (setf (coords gc) cc)))))))

;;; ============================================================================

(defparameter *model* nil)
(defclass/std model ()
  ((state)
   (grid :std (make-instance 'grid))
   (ui-width)
   (ui-height)
   (mouse-x)
   (mouse-y)))

(defclass state () nil)
(defclass init (state) nil)

(defclass/std msg () nil)
(defclass/std none (msg) nil)
(defclass/std init (msg) nil)
(defclass/std resize (msg) ((width) (height)))

;;; msg with inheritance
(defclass/std mouse-coords (msg) ((x) (y)))
(defclass/std mouse-motion (mouse-coords) nil)
(defclass/std mouse-enter  (mouse-coords) nil)
(defclass/std mouse-leave  (msg) nil)
(defclass/std mouse-gesture  (msg) ((button) (x) (y)))
(defclass/std mouse-pressed  (mouse-gesture) nil)
(defclass/std mouse-released (mouse-gesture) nil)

(defmethod update ((model model) (msg none))
    (warn "doing nothing"))
(defmethod update ((model model) (msg init))
  (warn "updating model")
  (setf (state model) (make-instance 'init)))
(defmethod update ((model model) (msg resize))
  (warn "updating model")
  (setf
   (ui-width  model) (width  msg)
   (ui-height model) (height msg))
  (adjust-coordinates model (grid model)))
(defmethod update ((model model) (msg mouse-coords))
  (setf (mouse-x model) (x msg)
        (mouse-y model) (y msg)))
(defmethod update ((model model) (msg mouse-leave))
  (setf (mouse-x model) nil
        (mouse-y model) nil))


(defmethod update ((model model) (msg mouse-pressed))
  (setf (mouse-x model) (x msg)
        (mouse-y model) (y msg))
  (warn "doing nothing with ~S and mode mouse ~S ~S" msg (mouse-x model) (mouse-y model)))

(defmethod update ((model model) (msg mouse-released))
  (warn "doing nothing with ~S" msg))
;;; ============================================================================

(defun event-sink (widget signal-name event &rest args)
  (let ((event-class (when event (format nil "~S" (slot-value event 'class)))))
    ;; (unless (member signal-name '("motion" "timeout") :test #'equalp)
    ;;   (format t "EEEEEEEEEEEEEEEEE ~S ~S ~S  --- ~S~%"
    ;;           event-class
    ;;           signal-name
    ;;           args
    ;;           *model*))
    (cond
      ((equalp event-class "#O<EventControllerMotion>")
       (cond
         ((equalp signal-name "motion")
          (destructuring-bind ((x y)) args
            (update *model* (make-instance 'mouse-motion :x x :y y))))
         ((equalp signal-name "enter")
          (destructuring-bind ((x y)) args
            (update *model* (make-instance 'mouse-enter :x x :y y))))
         ((equalp signal-name "leave")
          (update *model* (make-instance 'mouse-leave)))
         (t (error "unknown signal ~S~%" signal-name))))

      ((equalp event-class "#O<EventControllerKey>")
       (cond
         ((equalp signal-name "key-pressed")
          (destructuring-bind ((key-val key-code key-modifiers)) args
            (check-key key-val key-code key-modifiers)))
         (t (error "unknown signal ~S~%" signal-name))))

      ((equalp event-class "#O<GestureClick>")
       (cond
         ((equalp signal-name "pressed")
          (destructuring-bind ((button x y)) args
            (update *model* (make-instance 'mouse-pressed :button button :x x :y y))
            ;; FIXME tomorrow
            (widget-queue-draw widget)
            ))
         ((equalp signal-name "released")
          (destructuring-bind ((button x y)) args
            (update *model* (make-instance 'mouse-released :button button :x x :y y))))
         (t (error "unknown signal ~S~%" signal-name))))

      ((null event-class)
       (cond
         ((equalp signal-name "timeout")
          ;; (format t "timeout~%")
          )
         ((equalp signal-name "resize")
          (destructuring-bind ((width height)) args
            (update *model* (make-instance 'resize :width width :height height))))
         (t (error "unknown signal ~S~%" signal-name))))

      (T
       (warn "unknown event class")))))
;;; ============================================================================

(defun init-model ()
  (warn "init model")
  (setf *model* (make-instance 'model))
  (update *model* (make-instance 'init))
  *model*)

;;; main =======================================================================

;;; STARTING
;; (load "~/Programming/Pyrulis/Lisp/cl-gtk4-tictactoe.lisp")
;; (in-package #:cl-gtk4-tictactoe)
;;; (main)

(defun connect-controller (widget controller signal-name)
    (connect controller signal-name (lambda (event &rest args)
                                      (event-sink widget signal-name event args))))
(defun main ()
  (init-model)

  (let ((app (make-application :application-id "org.bigos.cl-gtk4-tictactoe"
                               :flags gio:+application-flags-flags-none+)))
    (connect app "activate"
             (lambda (app)
               (let ((window (make-application-window :application app)))

                 (glib:timeout-add 5000 (lambda (&rest args)
                                          (event-sink window "timeout" nil args)
                                          glib:+priority-default+))

                 ;; for some reason these do not work
                 ;; (let ((focus-controller (gtk4:make-event-controller-focus)))
                 ;;   (widget-add-controller window focus-controller)
                 ;;   (connect-controller window focus-controller "enter")
                 ;;   (connect-controller window focus-controller "leave"))

                 (let ((key-controller (gtk4:make-event-controller-key)))
                   (widget-add-controller window key-controller)
                   (connect-controller window key-controller "key-pressed"))

                 (setf (window-title        window) "Tic Tac Toe"
                       (window-default-size window) (list 400 400))
                 (let ((box (make-box :orientation +orientation-vertical+
                                      :spacing 0)))
                   (let ((canvas (gtk:make-drawing-area)))

                     (setf (drawing-area-content-width canvas) 200
                           (drawing-area-content-height canvas) 200
                           (widget-vexpand-p canvas) T
                           (drawing-area-draw-func canvas) (list (cffi:callback %draw-func)
                                                                 (cffi:null-pointer)
                                                                 (cffi:null-pointer)))

                     (let ((motion-controller (gtk4:make-event-controller-motion)))
                       (widget-add-controller canvas motion-controller)
                       (connect-controller canvas motion-controller "motion")
                       (connect-controller canvas motion-controller "enter")
                       (connect-controller canvas motion-controller "leave"))

                     (let ((gesture-click-controller (gtk4:make-gesture-click)))
                       (widget-add-controller canvas gesture-click-controller)
                       (connect-controller canvas gesture-click-controller "pressed")
                       (connect-controller canvas gesture-click-controller "released"))

                     (connect canvas "resize" (lambda (widget &rest args)
                                                (declare (ignore widget))
                                                (event-sink canvas "resize" nil args)))

                     (box-append box canvas))
                   (setf (window-child window)
                         box))
                 (window-present window))))
    (gio:application-run app nil))
  *model*)

;;; T for terminal
(when nil
  (main)
  (sb-ext:quit))
