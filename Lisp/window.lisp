;;; also consider these projects
;;; https://github.com/andy128k/cl-gobject-introspection
;; https://github.com/kat-co/gir2cl

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(:alexandria :serapeum :cl-cffi-gtk)))

(defpackage #:window
  (:use #:cl
        #:cffi
        #:gtk #:gdk #:gdk-pixbuf #:gobject #:glib #:gio #:pango #:cairo))

;; (load "/home/jacek/Programming/Pyrulis/Lisp/window.lisp")
(in-package :window)

;;; macros----------------------------------------------------------------------
(defvar *zzz*
  '(TYPECASE EVENT
    (GDK-EVENT-KEY
     (CASE (GDK-EVENT-KEY-TYPE EVENT)
       (:KEY-PRESS FUNC)
       (:KEY-RELEASE FUNC)))
    (GDK-EVENT-EXPOSE
     (CASE (GDK-EVENT-EXPOSE-TYPE EVENT)
       (:EXPOSE FUNC)))
    (GDK-EVENT-VISIBILITY
     (CASE (GDK-EVENT-VISIBILITY-TYPE EVENT)
       (:VISIBILITY-NOTIFY FUNC)))
    (GDK-EVENT-MOTION
     (CASE (GDK-EVENT-MOTION-TYPE EVENT)
       (:MOTION-NOTIFY FUNC)))
    (GDK-EVENT-BUTTON
     (CASE (GDK-EVENT-BUTTON-TYPE EVENT)
       (:BUTTON-PRESS FUNC)
       (:2BUTTON-PRESS FUNC)
       (:DOUBLE-BUTTON-PRESS FUNC)
       (:3BUTTON-PRESS FUNC)
       (:TRIPLE-BUTTON-PRESS FUNC)
       (:BUTTON-RELEASE FUNC)))
    (GDK-EVENT-TOUCH
     (CASE (GDK-EVENT-TOUCH-TYPE EVENT)
       (:TOUCH-BEGIN FUNC)
       (:TOUCH-UPDATE FUNC)
       (:TOUCH-END FUNC)
       (:TOUCH-CANCEL FUNC)))
    (GDK-EVENT-SCROLL
     (CASE (GDK-EVENT-SCROLL-TYPE EVENT)
       (:SCROLL FUNC)))
    (GDK-EVENT-CROSSING
     (CASE (GDK-EVENT-CROSSING-TYPE EVENT)
       (:ENTER-NOTIFY FUNC)
       (:LEAVE-NOTIFY FUNC)))
    (GDK-EVENT-FOCUS
     (CASE (GDK-EVENT-FOCUS-TYPE EVENT)
       (:FOCUS-CHANGE FUNC)))
    (GDK-EVENT-CONFIGURE
     (CASE (GDK-EVENT-CONFIGURE-TYPE EVENT)
       (:CONFIGURE FUNC)))
    (GDK-EVENT-PROPERTY
     (CASE (GDK-EVENT-PROPERTY-TYPE EVENT)
       (:PROPERTY-NOTIFY FUNC)))
    (GDK-EVENT-SELECTION
     (CASE (GDK-EVENT-SELECTION-TYPE EVENT)
       (:SELECTION-CLEAR FUNC)
       (:SELECTION-NOTIFY FUNC)
       (:SELECTION-REQUEST FUNC)))
    (GDK-EVENT-OWNER-CHANGE
     (CASE (GDK-EVENT-OWNER-CHANGE-TYPE EVENT)
       (:OWNER-CHANGE FUNC)))
    (GDK-EVENT-PROXIMITY
     (CASE (GDK-EVENT-PROXIMITY-TYPE EVENT)
       (:PROXIMITY-IN FUNC)
       (:PROXIMITY-OUT FUNC)))
    (GDK-EVENT-DND
     (CASE (GDK-EVENT-DND-TYPE EVENT)
       (:DRAG-ENTER FUNC)
       (:DRAG-LEAVE FUNC)
       (:DRAG-MOTION FUNC)
       (:DRAG-STATUS FUNC)
       (:DROP-START FUNC)
       (:DROP-FINISHED FUNC)))
    (GDK-EVENT-WINDOW-STATE
     (CASE (GDK-EVENT-WINDOW-STATE-TYPE EVENT)
       (:WINDOW-STATE FUNC)))
    (GDK-EVENT-SETTING
     (CASE (GDK-EVENT-SETTING-TYPE EVENT)
       (:SETTING FUNC)))
    (GDK-EVENT-GRAB-BROKEN
     (CASE (GDK-EVENT-GRAB-BROKEN-TYPE EVENT)
       (:GRAB-BROKEN FUNC)))))

;;; event structure=============================================================
;;; usual events
;; file:~/quicklisp/dists/quicklisp/software/cl-cffi-gtk-20201220-git/gdk/gdk.event-structures.lisp::915
;;; all signals
;; file:~/quicklisp/dists/quicklisp/software/cl-cffi-gtk-20201220-git/gtk/gtk.widget.lisp::424

(defvar *event-types* '(((:key-press :key-release) gdk-event-key
                         (time :uint32)
                         (state gdk-modifier-type)
                         (keyval :uint)
                         (length :int)
                         (string (:string :free-from-foreign nil
                                          :free-to-foreign nil))
                         (hardware-keycode :uint16)
                         (group :uint8)
                         (is-modifier :uint))

                        ((:expose) gdk-event-expose
                         (area gdk-rectangle :inline t)
                         (region (:pointer (:struct cairo-region-t)))
                         (count :int))

                        ((:visibility-notify) gdk-event-visibility
                         (state gdk-visibility-state))

                        ((:motion-notify) gdk-event-motion
                         (time :uint32)
                         (x :double)
                         (y :double)
                         (axes (fixed-array :double 2))
                         (state gdk-modifier-type)
                         (is-hint :int16)
                         (device (g-object gdk-device))
                         (x-root :double)
                         (y-root :double))

                        ((:button-press
                          :2button-press
                          :double-button-press
                          :3button-press
                          :triple-button-press
                          :button-release) gdk-event-button
                         (time :uint32)
                         (x :double)
                         (y :double)
                         (axes (fixed-array :double 2))
                         (state gdk-modifier-type)
                         (button :uint)
                         (device (g-object gdk-device))
                         (x-root :double)
                         (y-root :double))

                        ((:touch-begin
                          :touch-update
                          :touch-end
                          :touch-cancel) gdk-event-touch
                         (time :uint32)
                         (x :double)
                         (y :double)
                         (axes (fixed-array :double 2))
                         (state gdk-modifier-type)
                         (sequence (g-boxed-foreign gdk-event-sequence))
                         (emulating-pointer :boolean)
                         (device (g-object gdk-device))
                         (x-root :double)
                         (y-root :double))

                        ((:scroll) gdk-event-scroll
                         (time :uint32)
                         (x :double)
                         (y :double)
                         (state gdk-modifier-type)
                         (direction gdk-scroll-direction)
                         (device (g-object gdk-device))
                         (x-root :double)
                         (y-root :double)
                         (delta-x :double)
                         (delta-y :double)
                         #+gdk-3-20
                         (is-stop :uint)) ; bitfield

                        ((:enter-notify :leave-notify) gdk-event-crossing
                         (subwindow (g-object gdk-window))
                         (time :uint32)
                         (x :double)
                         (y :double)
                         (x-root :double)
                         (y-root :double)
                         (mode gdk-crossing-mode)
                         (detail gdk-notify-type)
                         (focus :boolean)
                         (state gdk-modifier-type))

                        ((:focus-change) gdk-event-focus
                         (in :int16))

                        ((:configure) gdk-event-configure
                         (x :int)
                         (y :int)
                         (width :int)
                         (height :int))

                        ((:property-notify) gdk-event-property
                         (atom gdk-atom)
                         (time :uint32)
                         (state gdk-property-state))

                        ((:selection-clear
                          :selection-notify
                          :selection-request) gdk-event-selection
                         (selection gdk-atom)
                         (target gdk-atom)
                         (property gdk-atom)
                         (time :uint32)
                         (requestor (g-object gdk-window)))

                        ((:owner-change) gdk-event-owner-change
                         (owner (g-object gdk-window))
                         (reason gdk-owner-change)
                         (selection gdk-atom)
                         (time :uint32)
                         (selection-time :uint32))

                        ((:proximity-in
                          :proximity-out) gdk-event-proximity
                         (time :uint32)
                         (device (g-object gdk-device)))

                        ((:drag-enter
                          :drag-leave
                          :drag-motion
                          :drag-status
                          :drop-start
                          :drop-finished) gdk-event-dnd
                         (context (g-object gdk-drag-context))
                         (time :uint32)
                         (x-root :short)
                         (y-root :short))

                        ((:window-state) gdk-event-window-state
                         (changed-mask gdk-window-state)
                         (new-window-state gdk-window-state))

                        ((:setting) gdk-event-setting
                         (action gdk-setting-action)
                         (name (:string :free-from-foreign nil :free-to-foreign nil)))

                        ((:grab-broken) gdk-event-grab-broken
                         (keyboard :boolean)
                         (implicit :boolean)
                         (grab-window (g-object gdk-window)))))

(defun trying ()
  `(typecase event
     ,@(loop for el in *event-types* collect
                                     (list (cadr el)
                                           `(case
                                                (,(symbol-with-suffix (cadr el) '-type) event)
                                              ,@(loop for vt in (car el)
                                                      collect (list  vt 'func)))))))

;;; TODO still needs more polish to have handlers for different widgets
(defun trying-again ()
  `(typecase event
     ,@(loop for el in *event-types*
             collect
             (list (cadr el)
                   `(,(symbol-with-suffix (cadr el) '-handler)
                     (,(symbol-with-suffix (cadr el) '-type) event)
                     ,@(loop for at in (cddr el) collect (list (symbol-with-suffix
                                                                (cadr el) (format nil "-~A"  (car at)))
                                                               'event))
                     )))))

(defun generate-handling (widget-name)
  `(defun ,(read-from-string (format nil "handling-~A" widget-name)) (widget event)
      , `(typecase event
          ,@(loop for el in *event-types*
                  collect
                  (list (cadr el)
                        `(,(symbol-with-suffix (cadr el)
                                               (format nil "-handler-~A" widget-name))
                          (,(symbol-with-suffix (cadr el) '-type) event)
                          ,@(loop for at in (cddr el) collect (list (symbol-with-suffix
                                                                     (cadr el) (format nil "-~A"  (car at)))
                                                                    'event))))))))
(defun generate-handlers (widget-name)
  `(list
     ,@(loop for el in *event-types*
             collect
             `(defun ,(read-from-string (format nil "~A-handler-~A" (cadr el) widget-name))
                  ,(cons 'type (loop for at in (cddr el) collect (car at)))

                (case type ,@(loop for et in (car el) collect (list et '(error "not implemented"))))))))

(defun symbol-with-suffix (symbol suffix)
  (read-from-string (format nil "~A~A" symbol suffix)))

;;; canvas======================================================================
(defun draw-canvas (model canvas context)
  (let* ((w (gtk-widget-get-allocated-width canvas))
         (h (gtk-widget-get-allocated-height canvas))
         (cr (pointer context)))
    ;; prevent cr being destroyed improperly
    (cairo-reference cr)

    (draw-canvas-lines cr model)

    ;; cleanup
    ;; cairo destroy must have matching cairo-reference
    (cairo-destroy cr)

    ;; continue propagation of the event handler
    +gdk-event-propagate+))

(defun inner (cr model)
  (let ((a (car model)))

    (when model
      (format t "~A~%" a )

      (progn
        (cairo-move-to cr
                       (* 1 (car a))
                       (* 1 (cdr a)))
        (cairo-line-to cr
                       (* 1 (car a))
                       (* 1 (cdr a))))
      (inner cr (cdr model)))))

(defun draw-canvas-lines (cr model)
  (cairo-set-source-rgb cr 0.6 0.9 0)
  (cairo-set-line-width cr 25)
  (cairo-set-line-cap cr :round)
  (cairo-set-line-join cr :round)

  ;; draw dots
  (cairo-set-source-rgb cr 0.4 0.6 0.1)
  (cairo-set-line-width cr 13)

  (inner cr model)

  (cairo-stroke cr))

;;; TODO play with drawing on canvas
;; file:~/quicklisp/dists/quicklisp/software/cl-cffi-gtk-20201220-git/demo/cairo-demo/cairo-demo.lisp::1
;; file:~/Programming/Pyrulis/Lisp/cairo-snake/cairo-snake.lisp::282
(defun draw-fun (canvas context)
  (let ((model *model*))
    (format t "model is ~A~%" model)
    (draw-canvas model canvas context)))

;;; event handling==============================================================
(defun canvas-event-fun (widget event)
  (let ((handled))
    (format t "~&================== we have canvas event ~A~%" (gdk-event-type event))

    (typecase event
      (gdk-event-button (case (gdk-event-button-type event)
                          (:button-press (handled (format t "button press event handling~%"))))))

    (unless handled
      (format t "the canvas event is not implemented~%~%")))
  +gdk-event-propagate+)

;; file:~/quicklisp/dists/quicklisp/software/cl-cffi-gtk-20201220-git/gdk/gdk.event-structures.lisp::920

(defmacro handled (&rest body)
  `(progn
     (setf handled t)
     ,@body))

;;; key event handling1=========================================================
(defun key-event-modifiers (event)
  ;; all masks
  ;; (:SHIFT-MASK :CONTROL-MASK :ALT-MASK :ALTGR-MASK :SUPER-MASK)
  (mapcar
   (lambda (y)                          ;translate alts
     (cond ((eq y :MOD1-MASK) :ALT)
           ((eq y :SHIFT-MASK) :SHIFT)
           ((eq y :CONTROL-MASK) :CONTROL)
           ((eq y :MOD5-MASK) :ALTGR)
           ((eq y :SUPER-MASK) :SUPER)
           (t y)))
   (remove-if
    (lambda (x)
      (member x '(:MOD2-MASK :MOD4-MASK)))
    (gdk-event-key-state event))))

(defun gdk-event-key-key-press (event)
  (format t "----~A~%" event)
  (let ((kn (gdk-keyval-name (gdk-event-key-keyval event)))
        (ks (key-event-modifiers event)))
    (format t "Pressed ~s ~s ~s~%" (gdk-event-key-string event) kn ks)
    (cond ((equal "F1" kn)
           (format t "~&----help----~%" )
           (format t "Ctrl-a - autocomplete ~%"))
          ((and (equal ks '())
                (equal kn "a"))
           (format t "pressed Just a~%"))
          ((and (equal ks '(:CONTROL))
                (equal kn "a"))
           (format t "pressed Ctrl-a~%"))
          ((and (equal ks '(:SHIFT :CONTROL))
                (equal kn "A"))
           (format t "pressed Ctrl-A~%"))
          ;; super
          ((and (equal ks '(:SUPER))
                (equal kn "a"))
           (format t "pressed Super-a~%"))
          ((and (equal ks '(:SHIFT :SUPER))
                (equal kn "A"))
           (format t "pressed Super-A~%"))

          ((and (equal ks '(:SHIFT :CONTROL :SUPER))
                (equal kn "A"))
           (format t "pressed Ctrl Super-A~%"))
          ((and (equal ks '(:CONTROL :SUPER))
                (equal kn "a"))
           (format t "pressed Ctrl Super-a~%"))
          ;; alt
          ((and (equal ks '(:ALT ))
                (equal kn "a"))
           (format t "pressed Alt-a~%"))

          ((and (equal ks '(:SHIFT :ALT))
                (equal kn "A"))
           (format t "pressed Alt-A~%"))
          ((and (equal ks '(:CONTROL :ALT))
                (equal kn "a"))
           (format t "pressed Ctrl Alt-a~%"))

          ((and (equal ks '(:SHIFT :CONTROL :ALT :SUPER))
                (equal kn "A"))
           (format t "pressed Shift Ctrl Alt Super-A~%"))

          ((and (equal ks '(:ALT :SUPER))
                (equal kn "a"))
           (format t "pressed Alt Super-a~%"))


          ((and (equal ks '(:ALTGR :SUPER))
                (equal kn "ae"))
           (format t "pressed AltGr Super-a~%"))

          (t
           (format t "ignored key ~s~%" kn)))) )
;;; key event handling2=========================================================

(defun win-event-fun (widget event)
  (format t "~&================== we have event ~s~%" (gdk-event-type event))
  (let ((handled))

    (typecase event
      (gdk-event-key (case (gdk-event-key-type event)
                       (:key-press  (handled (format t "key event key press~%")
                                             (gdk-event-key-key-press event))))))

    (unless handled
      (format t "=========the above event is not implemented=================~%~%~%"))))

;;; event for graceful closing of the window
(defun win-delete-event-fun (widget event)
  (declare (ignore widget))
  (format t "Delete Event Occured.~A~%" event)
  (if (zerop *do-not-quit*)
      (progn
        (format t "~&QUITTING~%")
        (leave-gtk-main)
        +gdk-event-propagate+)

      (progn
        (decf *do-not-quit*)
        (format t "~&not quitting yet ~A clicks more on close widget to go~%" (+ 1 *do-not-quit*))
        +gdk-event-stop+)))

;;; event handling helpers======================================================

;;; windows ====================================================================
(defun add-new-window (app)
  (let ((window (make-instance 'gtk-application-window
                               :application app
                               :title "New and better window"
                               :default-width 500
                               :default-height 300))
        (box (make-instance 'gtk-box
                            :border-width 1
                            :orientation :vertical
                            :spacing 1))
        (canvas (make-instance 'gtk-drawing-area
                               :width-request 500
                               :height-request 270)))

    ;; packing widgets
    (gtk-container-add window box)
    (gtk-box-pack-start box canvas)

    ;; signals

    ;; canvas events inherited from the widget
    (loop for ev in (list "configure-event"
                          "motion-notify-event"
                          "scroll-event"
                          "button-press-event"
                          "button-release-event")
       do (g-signal-connect canvas ev #'canvas-event-fun))
    ;; canvas events
    (g-signal-connect canvas "draw"
                      (lambda (widget context)
                        (draw-fun widget context)))

    (gtk-widget-add-events canvas '(:all-events-mask))

    ;; window events inherited form the widget
    (loop for ev in (list "key-press-event"
                          "key-release-event"
                          "enter-notify-event"
                          "leave-notify-event")
       do (g-signal-connect window ev #'win-event-fun))

    ;; Signal handler for closing the window and to handle the signal "delete-event".
    (g-signal-connect window "delete-event"  #'win-delete-event-fun)

    ;; finally show all widgets
    (gtk-widget-show-all window)))

(defvar *global-app* nil)
(defvar *do-not-quit* 3)
(defvar *model* nil)
;; https://www.gtk.org/docs/getting-started/hello-world/
(defun main-app ()
  (let ((argc 0)
        (argv (null-pointer)))
    (let ((app (gtk-application-new "try.window" :none)))
      (setf *global-app* app)
      (setf *do-not-quit* 2)
      (setf *button* nil)
      (setf *model* nil)
      (g-signal-connect app "activate" #'add-new-window)
      (let ((status (g-application-run app argc argv)))
        (g-object-unref (pointer app))
        status))))

(defun debug-app ()
  "This allows me to interact with *model* using REPL"
  (setf *do-not-quit* 2)
  (setf *global-app*  (gtk-application-new "weeee" :none))
  ;; ==== we may not need this one === (g-application-register *global-app* nil)
  (g-application-activate *global-app*)
  (within-main-loop (add-new-window *global-app*)))

;;; after quitting run the following
;;; (g-object-unref (pointer *global-app*))


;; (load "/home/jacek/Programming/Pyrulis/Lisp/window.lisp")
;; (in-package :window)
;; (main-app)
