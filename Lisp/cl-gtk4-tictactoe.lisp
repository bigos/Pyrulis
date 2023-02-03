(declaim (optimize (speed 0) (safety 2) (debug 3)))

(cl:in-package "CL-USER")

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(cl-gtk4
                  cl-gdk4
                  cl-glib
                  cl-gobject
                  cl-cairo2
                  serapeum
                  defclass-std
                  fiveam)))

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


;;; classes ====================================================================

;; add coverage testing
;; http://www.sbcl.org/manual/index.html#sb_002dcover

(defparameter *model* nil)
(defclass/std model ()
  ((state)
   (next-placed :std :o)
   (my-grid :std (make-instance 'field-grid))
   (ui-width)
   (ui-height)
   (mouse-x)
   (mouse-y)))

(defclass/std state    ()      nil)
(defclass/std init     (state) nil)
(defclass/std playing  (state) nil)
(defclass/std no-moves (state) nil) ; no empty fields left and usually no side wins
(defclass/std won      (state)
  ((winner)))

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

(defclass/std grid-cell ()
  ((name)
   (state)
   (mouse)
   (coords)))

;;; grid cells are numbered after the keys on the numeric keypad with 1 being
;; bottom left and 9 being top right
(defclass/std field-grid ()
  ((c1 :std (make-instance 'grid-cell :name 'c1))
   (c2 :std (make-instance 'grid-cell :name 'c2))
   (c3 :std (make-instance 'grid-cell :name 'c3))
   (c4 :std (make-instance 'grid-cell :name 'c4))
   (c5 :std (make-instance 'grid-cell :name 'c5))
   (c6 :std (make-instance 'grid-cell :name 'c6))
   (c7 :std (make-instance 'grid-cell :name 'c7))
   (c8 :std (make-instance 'grid-cell :name 'c8))
   (c9 :std (make-instance 'grid-cell :name 'c9))))

;;; object printing ============================================================
(defmethod print-object ((obj standard-object) stream)
  (print-unreadable-object (obj stream :type t)
    (format stream "~S"
            (loop for sl in (sb-mop:compute-slots (class-of obj))
                  collect (list
                           (sb-mop:slot-definition-name sl)
                           (slot-value obj (sb-mop:slot-definition-name sl)))))))

(defmethod print-object ((obj grid-cell) stream)
  (print-unreadable-object (obj stream :type t)
    (format stream "~A/~A/~A/"             ;we hide coordinates
            (name  obj)
            (state obj)
            (mouse obj))))

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

  ;; (warn "drawing ~S ~S === ~S ~S" width height (ui-width model) (ui-height model))

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

      (with-gdk-rgba (color "#668844FF")
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
        ;; (with-gdk-rgba (color "#777777CC")
        ;;   (gdk:cairo-set-source-rgba cr color))
        ;; (square-centered-at hw hh (+ (* size 3) (* size 0.20)))

        ;; grid
        ;; (with-gdk-rgba (color "#FFFFFFCC")
        ;;   (gdk:cairo-set-source-rgba cr color))
        ;; (square-centered-at (- hw dist) (- hh dist) size)
        ;; (square-centered-at (- hw dist) hh size)
        ;; (square-centered-at (- hw dist) (+ hh dist) size)

        ;; (square-centered-at hw (- hh dist) size)
        ;; (square-centered-at hw hh size)
        ;; (square-centered-at hw (+ hh dist) size)

        ;; (square-centered-at (+ hw dist) (- hh dist) size)
        ;; (square-centered-at (+ hw dist) hh size)
        ;; (square-centered-at (+ hw dist) (+ hh dist) size)

        ;; top bar
        (with-gdk-rgba (color "#FFFFD0F0")
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


        (with-gdk-rgba (color "#441111FF")
          (gdk:cairo-set-source-rgba cr color))
        (cairo:select-font-face "Ubuntu Mono"
                                :normal :bold)
        (cairo:set-font-size (* size 0.5))
        (cairo:move-to (- hw (* size 1.75)) (- hh (* size 1.72)))
        (cairo:show-text (format nil "~A"
                                 (etypecase  (state model)
                                   (init     (format nil "Place ~A" (next-placed model)))
                                   (playing  (format nil "Place ~A" (next-placed model)))
                                   (won      (format nil "~A has won" (winner (state model))))
                                   (no-moves (format nil "~A no moves" (state model))))))

        ;; help area
        ;; (with-gdk-rgba (color "#88FFFFAA")
        ;;   (gdk:cairo-set-source-rgba cr color))
        ;; (cairo:rectangle (- hw (* size 2) 10)
        ;;                  (- hh (* size 2))
        ;;                  (+ (* size 4) (* 2 10))
        ;;                  (* size 4))
        ;; (cairo:fill-path)
        )))



  ;; procedural method part::::::::::::::::::::::::::::::::::::::::::
  (let ((size (/ (min (ui-width model) (ui-height model))
                 4.5)))
    (loop for cell-name in '(c7 c8 c9
                             c4 c5 c6
                             c1 c2 c3)
          for redval = 250
          do (let* ((gc (slot-value (my-grid model) cell-name))
                    (cc  (coords gc))
                    (cm (mouse gc)))
               (with-gdk-rgba (color (if cm (ecase cm
                                              (:clicked "#FFAA88FF")
                                              (:hover   "#AAFF88FF"))

                                         (rgbahex redval redval redval  255)))
                 (gdk:cairo-set-source-rgba cr color)
                 (square-centered-at (caar cc) (cdar cc) size)
                 (cairo:fill-path))
               (with-gdk-rgba (color (cond
                                       ((eql 'won (type-of (state model) ))
                                        (cond
                                          ((eql (state gc)
                                                (winner (state model)))
                                           (cond
                                             ((member (name gc)
                                                      (caar (get-all-lines (my-grid model)))
                                                      :test #'equalp)
                                              "#FF0000FF")
                                             (t
                                              "#A01122FF"))
                                           )
                                          (t "#221122aa")))
                                       (T "#221122FF")))

                 (gdk:cairo-set-source-rgba cr color)
                 (cairo:select-font-face "Ubuntu Mono"
                                         :normal :bold)
                 (cairo:set-font-size (* size 0.5))
                 (cairo:move-to (caar cc) (cdar cc))
                 (cairo:show-text (format nil "~A" (if (state gc)
                                                       (ecase (state gc)
                                                         (:x "X")
                                                         (:o "O"))
                                                       "")))))))

  (progn
    ;; (format t "mouse coord ~S ~S~%" (mouse-x model) (mouse-y model))
    (when (mouse-x model)
      (cairo:rectangle (mouse-x model)
                       (mouse-y model)
                       25
                       25))

    (with-gdk-rgba (color "#FFFFBBFF")
      (gdk:cairo-set-source-rgba cr color))
    (cairo:fill-path)))


  ;; (format t "nearest grid cells ~S~%" (nearest-grid-cells model))
  ;; (format t "mouse state ~S ~S~%" (mouse-x model) (mouse-y model))


;;; ================ end of draw-func ==========================================


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
(defun rgbahex (r g b a)
  (format nil
          "#~2,'0X~2,'0X~2,'0X~2,'0X"
          r g b a))
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
(defun centered-at (x y size)
  "Get coordinates of square of SIZE centred at X Y."
  (list (cons x
              y)
        (cons (+ x size)
              (+ y size))))

;;; ============================================================================
(defmethod place-ox ((grid field-grid) (cell symbol) (ox symbol))
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

(defmethod get-all-cells ((grid field-grid))
  (loop for c in '(c1 c2 c3 c4 c5 c6 c7 c8 c9)
        collect (slot-value grid c)))

(defmethod get-rows ((grid field-grid) (cell symbol))
  (get-grid-cells% grid (ecase cell
                          (c1 '(c1 c2 c3))
                          (c4 '(c4 c5 c6))
                          (c7 '(c7 c8 c9)))))

(defmethod get-columns ((grid field-grid) (cell symbol))
  (get-grid-cells% grid (ecase cell
                         (c7 '(c7 c4 c1))
                         (c8 '(c8 c5 c2))
                         (c9 '(c9 c6 c3)))))

(defmethod get-diagonals ((grid field-grid) (cell symbol))
  (get-grid-cells% grid (ecase cell
                         (c7 '(c7 c5 c3))
                         (c9 '(c9 c5 c1)))))

;;; determine the winner after the move
(defmethod get-all-lines ((grid field-grid))
  (let ((sets '((c1 c2 c3)
                (c4 c5 c6)
                (c7 c8 c9)
                ;; -------
                (c7 c4 c1)
                (c8 c5 c2)
                (c9 c6 c3)
                ;; -------
                (c7 c5 c3)
                (c9 c5 c1))))
    (loop for set in sets
          for cells = (get-grid-cells% grid set)
          when (or (equalp cells '(:o :o :o))
                   (equalp cells '(:x :x :x)))
            collect (list set cells))))

(defmethod adjust-coordinates ((model model) (grid field-grid))
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

(defmethod toggle-next-placed ((model model))
  (setf (next-placed model)
        (ecase (next-placed model)
          (:o :x)
          (:x :o))))

(defmethod all-grid-cells ((model model))
  (loop for c in '(c1 c2 c3 c4 c5 c6 c7 c8 c9)
        for gc = (funcall c (my-grid model))
        collect gc))

(defmethod nearest-grid-cells ((model model))
  (when (and (mouse-x model)
             (mouse-y model))
    (loop for c in '(c1 c2 c3 c4 c5 c6 c7 c8 c9)
          for gc = (funcall c (my-grid model))
          for mx = (mouse-x model)
          for my = (mouse-y model)
          for cc = (car (coords gc))
          for dx = (abs (- mx (car cc) ))
          for dy = (abs (- my (cdr cc)))
          for dist = (/ (min (ui-width model)
                             (ui-height model))
                        8.6)
          when (and (< dx dist) (< dy dist))
            collect gc)))

(defmethod mark-nearest ((model model) state)
  (loop for c in (all-grid-cells model)
        do (setf (mouse c) nil))
  (loop for c in (nearest-grid-cells model)
        do (setf (mouse c) (if (member state '(:clicked :hover))
                               state
                               (error "~S is invalid state" state)))))

(defmethod place-placed ((model model))
  (let ((c (car (nearest-grid-cells model))))
    (when c
      (setf (state c) (next-placed model))
      (toggle-next-placed model))))

;;; ============================================================================

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
  (adjust-coordinates model (my-grid model)))
(defmethod update ((model model) (msg mouse-coords))
  (setf (mouse-x model) (x msg)
        (mouse-y model) (y msg))
  (mark-nearest model :hover))
(defmethod update ((model model) (msg mouse-leave))
  (setf (mouse-x model) nil
        (mouse-y model) nil))

(defmethod update ((model model) (msg mouse-pressed))
  (setf (mouse-x model) (x msg)
        (mouse-y model) (y msg))
  (labels ((marking ()
             (mark-nearest model :clicked)
             (place-placed model)))
    (etypecase (state model)
      (init
       (marking)
       (setf (state model) (make-instance 'playing)))
      (playing
       (marking)
       (progn
         (let ((all-lines (get-all-lines (my-grid model))))
           (when all-lines
             (format t "~&>>>>>>>>>>>>> winning placements ~S~%" all-lines)
             (destructuring-bind ((cells placements) &rest rest) all-lines
               (setf (state model) (make-instance 'won :winner (car placements)))
               (format t "cells ~S placements ~S ~%" cells placements))))
         (let ((empty-fields (loop for c in (get-all-cells (my-grid model)) when (null (state c)) collect c)))
           (when (endp empty-fields)
             (unless (typep (state model) 'won)
               (setf (state model) (make-instance 'no-moves)))))))
      (won
       (format t "doing nothing after victory~%"))
      (no-moves
       (format t "doing nothing because no more moves possible~%"))))

  (format t "mouse pressed~%" ))

(defmethod update ((model model) (msg mouse-released))
  (mark-nearest model :hover))
;;; ============================================================================

;;; used for testing
(defun event-sink-test (signal-name event-class &rest args)
  (event-sink% nil signal-name event-class args))

(defun event-sink (widget signal-name event &rest args)
  (let ((event-class (when event (format nil "~S" (slot-value event 'class)))))
    (unless (member signal-name '("motion"
                                  "timeout"
                                  )
                    :test #'equalp)
      (format t "EEEEEEEEEEEEEEEEE ~S ~S ~S  --- ~S~%"
              event-class
              signal-name
              args
              *model*))
    (event-sink% widget signal-name event-class args)))

(defun event-sink% (widget signal-name event-class args)
    (cond
      ((equalp event-class "#O<EventControllerMotion>")
       (cond
         ((equalp signal-name "motion")
          (destructuring-bind ((x y)) args
            (format t "mouse moution ~S ~S~%" x y)
            (update *model* (make-instance 'mouse-motion :x x :y y))
            (when widget
              (widget-queue-draw widget))))
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
            (when widget
              (widget-queue-draw widget))
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
       (error "unknown event class ~S" event-class))))

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

(defun main-menubar (app menubar window)
  (let* ((menubar-item-menu (gio:make-menu-item :label "Menu" :detailed-action nil ))
         (menu (gio:make-menu))
         (menu-item-preferences (gio:make-menu-item :label "Preferences"
                                                    :detailed-action
                                                    (let ((act-preferences (gio:make-simple-action :name "preferences" :parameter-type nil)))
                                                      (gio:action-map-add-action app act-preferences)
                                                      (connect act-preferences "activate"
                                                               (lambda (&rest args)
                                                                 (warn
                                                                  ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ... preferences action ~S" args)))
                                                      (gobject:object-unref act-preferences)
                                                      "app.preferences")))
         (menu-item-quit (gio:make-menu-item :label "Quit"
                                             :detailed-action
                                             (let  ((act-quit (gio:make-simple-action :name "quit" :parameter-type nil)))
                                               (gio:action-map-add-action app act-quit)
                                               (connect act-quit "activate" (lambda (&rest args)
                                                                              (warn ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ... quit action ~S" args)
                                                                              ;; this quits the app without closing thew window

                                                                              ;; https://docs.gtk.org/glib/main-loop.html
                                                                              ;; may still need to close all windows
                                                                              ;; (gtk4:application-remove-window app window)
                                                                              (gtk4:window-close window)
                                                                              ;; (glib:main-loop-quit app)
                                                                              ;; (gio:application-quit app)
                                                                              ))
                                               (gobject:object-unref act-quit)
                                               "app.quit")))
         (menubar-item-help (gio:make-menu-item :label "Help" :detailed-action nil))
         (help (gio:make-menu))
         (help-item-manual (gio:make-menu-item :label "Manual"
                                               :detailed-action nil))
         (help-item-about (gio:make-menu-item :label "About"
                                              :detailed-action nil)))
    (gio:menu-append-item menu menu-item-preferences)
    (gio:menu-append-item menu menu-item-quit)
    (setf (gio:menu-item-submenu menubar-item-menu) menu)
    (gio:menu-append-item menubar menubar-item-menu)

    (gobject:object-unref menu-item-preferences)
    (gobject:object-unref menu-item-quit)
    (gobject:object-unref menu)
    (gobject:object-unref menubar-item-menu)

    (gio:menu-append-item help help-item-manual)
    (gio:menu-append-item help help-item-about)
    (setf (gio:menu-item-submenu menubar-item-help) help)
    (gio:menu-append-item menubar menubar-item-help)

    (gobject:object-unref help-item-about)
    (gobject:object-unref help)
    (gobject:object-unref menubar-item-help)))

(defun connect-controller (widget controller signal-name)
  (connect controller signal-name (lambda (event &rest args)
                                    (event-sink widget signal-name event args))))
(defun main ()
  (init-model)
  (let ((stat nil))
    (let ((app (make-application :application-id "org.bigos.cl-gtk4-tictactoe"
                                 :flags gio:+application-flags-flags-none+)))
      (connect app "activate"
               (lambda (app)
                 (let ((window (make-application-window :application app)))

                   (glib:timeout-add 1000
                                     (lambda (&rest args)
                                       (event-sink window "timeout" nil args)
                                       glib:+source-continue+))

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

                   (let ((menubar (gio:make-menu)))
                     (main-menubar app menubar window)
                     (setf
                      (gtk4:application-menubar app) menubar
                      (gtk4:application-window-show-menubar-p window) T)
                     (gobject:object-unref menubar))

                   (window-present window))))

      (setf stat (gio:application-run app nil))
      (format t "~S~%" *model*)
      (gobject:object-unref app))
    stat))

;;; T for terminal
(when nil
  (main)
  (sb-ext:quit))

;; :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

(in-package "CL-USER")
(defpackage #:cl-gtk4-tictactoe/tests
  (:use #:cl
        #:fiveam
        #:cl-gtk4-tictactoe)
  ;; because we need easier package prefix for symbols
  (:local-nicknames (:ttt :cl-gtk4-tictactoe))
  ;; import global and tested functions
  (:import-from #:cl-gtk4-tictactoe
   :*model*                             ; globals
   :c1 :c2 :c3 :c4 :c5 :c6 :c7 :c8 :c9  ; methods and functions
   :coords
   :event-sink-test
   :get-all-cells
   :get-all-lines
   :init-model
   :mouse
   :my-grid
   :name
   :nearest-grid-cells
   :next-placed
   :state
   :ui-height
   :ui-width
   :winner)
  (:export #:run!
           #:all-tests))

(in-package #:cl-gtk4-tictactoe/tests)

;;; running
;; (ttt::main)

;;; testing
;; (load "~/Programming/Pyrulis/Lisp/cl-gtk4-tictactoe.lisp")
;; (cl-gtk4-tictactoe/tests:run!)
;; (in-package #:cl-gtk4-tictactoe/tests)
;;; (run!)

(defun grid-name-mouse ()
  (loop for c in  (get-all-cells (my-grid  *model*))
        collect (list (name c) (mouse c))))

(defun grid-name-state-mouse ()
  (loop for c in  (get-all-cells (my-grid  *model*))
        collect (list (name c) (state c) (mouse c))))

(def-suite my-suite
  :description "Test my system")

(in-suite my-suite)

(setf
 fiveam:*verbose-failures* T
 fiveam:*on-error* :DEBUG)

(test my-tests
  "Example"
  (is (= 4 (+ 2 2)) "2 plus 2 wasn't equal to 4 (using #'= to test equality)")
  (is (= 0 (+ -1 1)))
  (signals
      (error "Trying to divide by zero didn't signal an error")
    (/ 2 0))
  ;; (is (= 0 (+ 1 1)) "this should have failed")
  )

(test mouse-movement
  "Testing mouse movement and cell hovering"
  (setf *model* nil)
  (is (null *model*))
  (let ((model (init-model)))
    (is (eql (type-of model) 'ttt::model))
    (event-sink-test "resize" nil                         '(400 400))
    (is (= 400 (ui-width  model)))
    (is (= 400 (ui-height model)))
    (event-sink-test "motion" "#O<EventControllerMotion>" '(0 0))
    (is (null (nearest-grid-cells model)))
    (is (equalp (grid-name-mouse)
                '((C1 NIL) (C2 NIL) (C3 NIL) (C4 NIL) (C5 NIL)
                  (C6 NIL) (C7 NIL) (C8 NIL) (C9 NIL))))


    (event-sink-test "motion" "#O<EventControllerMotion>" '(100 100))
    (is-false (null (car (nearest-grid-cells model))))
    (is (equalp (coords (c7 (my-grid  model)))
                '((106.66667 . 106.66667) (195.55556 . 195.55556))))
    (is (equalp (grid-name-mouse)
                '((C1 NIL) (C2 NIL) (C3 NIL) (C4 NIL) (C5 NIL)
                  (C6 NIL) (C7 :HOVER) (C8 NIL) (C9 NIL))))

    (event-sink-test "motion" "#O<EventControllerMotion>" '(100 200))
    (is-false (null (car (nearest-grid-cells model))))
    (is (equalp (coords (c4 (my-grid  model)))
                '((106.66667 . 200) (195.55556 . 288.8889))))
    (is (eq :hover (mouse (c4 (my-grid  model)))))
    (is (equalp (grid-name-mouse)
                '((C1 NIL) (C2 NIL) (C3 NIL) (C4 :HOVER) (C5 NIL)
                  (C6 NIL) (C7 NIL) (C8 NIL) (C9 NIL))))

    (event-sink-test "motion" "#O<EventControllerMotion>" '(100 290))
    (is-false (null (car (nearest-grid-cells model))))
    (is (equalp (coords (c1 (my-grid  model)))
                '((106.66667 . 293.3333) (195.55556 . 382.2222))))
    (is (equalp (grid-name-mouse)
                '((C1 :HOVER) (C2 NIL) (C3 NIL) (C4 NIL) (C5 NIL)
                 (C6 NIL) (C7 NIL) (C8 NIL) (C9 NIL))))


    (event-sink-test "motion" "#O<EventControllerMotion>" '(333 65))
    (is (equalp (coords (c9 (my-grid  model)))
                '((293.3333 . 106.66667) (382.2222 . 195.55556))))
    (is (equalp (grid-name-mouse)
                '((C1 NIL) (C2 NIL) (C3 NIL) (C4 NIL) (C5 NIL)
                 (C6 NIL) (C7 NIL) (C8 NIL) (C9 :HOVER))))))

(test mouse-clicks-winning
  "Testing mouse movement and clicks leading to win"
  (setf *model* nil)
  (is (null *model*))
  (let ((model (init-model)))
    (event-sink-test "resize" nil                         '(400 400))
    (is (= 400 (ui-width  model)))
    (is (= 400 (ui-height model)))

    (event-sink-test "motion" "#O<EventControllerMotion>" '(10 10))
    (is (null (nearest-grid-cells model)))
    ;; c7 o
    (event-sink-test "motion" "#O<EventControllerMotion>" '(70 70))
    (is-false (null (nearest-grid-cells model)))
    (is (equalp (grid-name-state-mouse)
                '((C1 NIL NIL) (C2 NIL NIL) (C3 NIL NIL) (C4 NIL NIL)
                  (C5 NIL NIL) (C6 NIL NIL) (C7 NIL :HOVER) (C8 NIL NIL)
                  (C9 NIL NIL))))

    (event-sink-test "pressed" "#O<GestureClick>" '(1 70 70))
    (is (equalp (grid-name-state-mouse)
                '((C1 NIL NIL) (C2 NIL NIL) (C3 NIL NIL) (C4 NIL NIL)
                  (C5 NIL NIL) (C6 NIL NIL) (C7 :O :CLICKED) (C8 NIL NIL)
                  (C9 NIL NIL))))
    ;; c8 x
    (event-sink-test "motion" "#O<EventControllerMotion>" '(175 85))
    (is-false (null (nearest-grid-cells model)))
    (is (equalp (grid-name-state-mouse)
                '((C1 NIL NIL) (C2 NIL NIL) (C3 NIL NIL) (C4 NIL NIL)
                  (C5 NIL NIL) (C6 NIL NIL) (C7 :O NIL) (C8 NIL :HOVER)
                  (C9 NIL NIL))))

    (event-sink-test "pressed" "#O<GestureClick>" '(1 175 85))
    (is (equalp (grid-name-state-mouse)
                '((C1 NIL NIL) (C2 NIL NIL) (C3 NIL NIL) (C4 NIL NIL)
                 (C5 NIL NIL) (C6 NIL NIL) (C7 :O NIL) (C8 :X :CLICKED)
                 (C9 NIL NIL))))
    ;; c4 o
    (event-sink-test "motion" "#O<EventControllerMotion>" '(100 200))
    (is-false (null (nearest-grid-cells model)))
    (is (equalp (grid-name-state-mouse)
                '((C1 NIL NIL) (C2 NIL NIL) (C3 NIL NIL) (C4 NIL :HOVER)
                  (C5 NIL NIL) (C6 NIL NIL) (C7 :O NIL) (C8 :X NIL)
                  (C9 NIL NIL))))

    (event-sink-test "pressed" "#O<GestureClick>" '(1 100 200))
    (is (equalp (grid-name-state-mouse)
                '((C1 NIL NIL) (C2 NIL NIL) (C3 NIL NIL) (C4 :O :CLICKED)
                  (C5 NIL NIL) (C6 NIL NIL) (C7 :O NIL) (C8 :X NIL)
                  (C9 NIL NIL))))

    ;; c9 x
    (event-sink-test "motion" "#O<EventControllerMotion>" '(333 65))
    (is-false (null (nearest-grid-cells model)))
    (is (equalp (grid-name-state-mouse)
                '((C1 NIL NIL) (C2 NIL NIL) (C3 NIL NIL) (C4 :O NIL)
                  (C5 NIL NIL) (C6 NIL NIL) (C7 :O NIL) (C8 :X NIL)
                  (C9 NIL :HOVER))))

    (event-sink-test "pressed" "#O<GestureClick>" '(1 333 65))
    (is (equalp (grid-name-state-mouse)
                '((C1 NIL NIL) (C2 NIL NIL) (C3 NIL NIL) (C4 :O NIL)
                 (C5 NIL NIL) (C6 NIL NIL) (C7 :O NIL) (C8 :X NIL)
                 (C9 :X :CLICKED))))

    ;; c1 o
    (event-sink-test "motion" "#O<EventControllerMotion>" '(100 290))
    (is-false (null (nearest-grid-cells model)))
    (is (equalp (grid-name-state-mouse)
                '((C1 NIL :HOVER) (C2 NIL NIL) (C3 NIL NIL) (C4 :O NIL)
                 (C5 NIL NIL) (C6 NIL NIL) (C7 :O NIL) (C8 :X NIL)
                 (C9 :X NIL))))

    (is (equal (type-of (state model)) 'ttt::playing))
    ;; winning move
    (event-sink-test "pressed" "#O<GestureClick>" '(1 100 290))
    (is (equalp (grid-name-state-mouse)
                '((C1 :O :CLICKED) (C2 NIL NIL) (C3 NIL NIL) (C4 :O NIL)
                 (C5 NIL NIL) (C6 NIL NIL) (C7 :O NIL) (C8 :X NIL)
                 (C9 :X NIL))))
    (is (equal (type-of (state model)) 'ttt::won))
    (is (equal (winner (state model)) :o))
    ;; now player x clicking on the grid should not do anything

    ;; c6 x
    (event-sink-test "motion" "#O<EventControllerMotion>" '(285 200))
    (is-false (null (nearest-grid-cells model)))
    (is (equalp (grid-name-state-mouse)
                '((C1 :O NIL) (C2 NIL NIL) (C3 NIL NIL) (C4 :O NIL)
                  (C5 NIL NIL) (C6 NIL :HOVER) (C7 :O NIL) (C8 :X NIL)
                  (C9 :X NIL))))

    ;; the c6 cell is still supposed to be in hover state
    (event-sink-test "pressed" "#O<GestureClick>" '(1 285 200))
    (is (equalp (grid-name-state-mouse)
               ' ((C1 :O NIL) (C2 NIL NIL) (C3 NIL NIL) (C4 :O NIL)
                 (C5 NIL NIL) (C6 NIL :HOVER) (C7 :O NIL) (C8 :X NIL)
                 (C9 :X NIL))))
    (is (equalp (get-all-lines (my-grid model))
                '(((C7 C4 C1) (:O :O :O)))))))

(test mouse-clicks-draw
  "Testing mouse clicks leading to draw."
  (setf *model* nil)
  (is (null *model*))
  (let ((model (init-model)))
    (event-sink-test "resize" nil                         '(400 400))
    (is (= 400 (ui-width  model)))
    (is (= 400 (ui-height model)))

    (event-sink-test "pressed" "#O<GestureClick>" '(1 100 100))
    (event-sink-test "pressed" "#O<GestureClick>" '(1 300 300))
    (event-sink-test "pressed" "#O<GestureClick>" '(1 100 300))
    (event-sink-test "pressed" "#O<GestureClick>" '(1 300 100))
    (is (equalp (grid-name-state-mouse)
                '((C1 :O NIL) (C2 NIL NIL) (C3 :X NIL) (C4 NIL NIL)
                  (C5 NIL NIL) (C6 NIL NIL) (C7 :O NIL) (C8 NIL NIL)
                  (C9 :X :CLICKED))))

    (event-sink-test "pressed" "#O<GestureClick>" '(1 300 200))
    (event-sink-test "pressed" "#O<GestureClick>" '(1 100 200))
    (event-sink-test "pressed" "#O<GestureClick>" '(1 200 100))
    (event-sink-test "pressed" "#O<GestureClick>" '(1 200 300))
    (is (equalp (grid-name-state-mouse)
                '((C1 :O NIL) (C2 :X :CLICKED) (C3 :X NIL) (C4 :X NIL)
                  (C5 NIL NIL) (C6 :O NIL) (C7 :O NIL) (C8 :O NIL)
                  (C9 :X NIL))))
    (is (equal
         (loop for c in  (get-all-cells (my-grid  *model*)) collect (state c))
         '(:O :X :X :X NIL :O :O :O :X)))
    (is (equal (type-of (state model)) 'ttt::playing))

    (event-sink-test "pressed" "#O<GestureClick>" '(1 200 200))
    (is (equalp (grid-name-state-mouse)
                '((C1 :O NIL) (C2 :X NIL) (C3 :X NIL) (C4 :X NIL)
                  (C5 :O :CLICKED) (C6 :O NIL) (C7 :O NIL) (C8 :O NIL)
                  (C9 :X NIL))))
    (is (equal
         (loop for c in  (get-all-cells (my-grid  *model*)) collect (state c))
         '(:O :X :X :X :O :O :O :O :X)))
    (is (eql (type-of (state model)) 'ttt::no-moves))))

;;; oxx
;;; xox
;;; oo.

(test last-move-win
  "Testing interesting special case where last move wins along two lines."
  (setf *model* nil)
  (is (null *model*))
  (let ((model (init-model)))
    (event-sink-test "resize" nil                         '(400 400))
    (is (= 400 (ui-width  model)))
    (is (= 400 (ui-height model)))

    (event-sink-test "pressed" "#O<GestureClick>" '(1 100 100)) ; o7
    (event-sink-test "pressed" "#O<GestureClick>" '(1 100 200)) ; x4
    (event-sink-test "pressed" "#O<GestureClick>" '(1 100 300)) ; o1
    (event-sink-test "pressed" "#O<GestureClick>" '(1 200 100)) ; x8
    (event-sink-test "pressed" "#O<GestureClick>" '(1 200 200)) ; o5
    (event-sink-test "pressed" "#O<GestureClick>" '(1 300 100)) ; x9
    (event-sink-test "pressed" "#O<GestureClick>" '(1 200 300)) ; o2
    (is (equalp (grid-name-state-mouse)
                '((C1 :O NIL) (C2 :O :CLICKED) (C3 NIL NIL) (C4 :X NIL) (C5 :O NIL) (C6 NIL NIL)
                 (C7 :O NIL) (C8 :X NIL) (C9 :X NIL))))
    (is  (eql (ttt::next-placed  model) :X))
    (event-sink-test "pressed" "#O<GestureClick>" '(1 300 200)) ; x6
    (is (equalp (grid-name-state-mouse)
                '((C1 :O NIL) (C2 :O NIL) (C3 NIL NIL) (C4 :X NIL) (C5 :O NIL) (C6 :X :CLICKED)
                 (C7 :O NIL) (C8 :X NIL) (C9 :X NIL))))
    (is (typep (state model) 'ttt::playing))
    (is  (eql (next-placed  model) :O))
    (event-sink-test "pressed" "#O<GestureClick>" '(1 300 300)) ; o3
    (is (equalp (grid-name-state-mouse)
                '((C1 :O NIL) (C2 :O NIL) (C3 :O :CLICKED) (C4 :X NIL) (C5 :O NIL) (C6 :X NIL)
                  (C7 :O NIL) (C8 :X NIL) (C9 :X NIL))))
    (is (typep (state model) 'ttt::won))
    (is (eql (winner (state model)) :O))))
