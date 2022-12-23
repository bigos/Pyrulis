(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(cl-gtk4 cl-cairo2)))

(defpackage cl-gtk4
  (:use #:cl #:gtk4))

;; (load "~/Programming/Pyrulis/Lisp/cl-gtk4.lisp")
(in-package #:cl-gtk4)

;; gtk_drawing_area_set_draw_func (GTK_DRAWING_AREA (drawing_area), draw_cb, NULL, NULL);
(sb-alien:define-alien-routine gtk_drawing_area_set_draw_func sb-alien:void
  (self (sb-alien:* t))
  (draw_func (sb-alien:function sb-alien:void
                                (sb-alien:* t)
                                (sb-alien:* t)
                                sb-alien:int
                                sb-alien:int
                                (sb-alien:* t)))
  (user_data (sb-alien:* t))
  (destroy (sb-alien:* t)))

(sb-alien:define-alien-callable draw-callback sb-alien:void
    ((widget (sb-alien:* t))
     (cr     (sb-alien:* t))
     (width  sb-alien:int )
     (height sb-alien:int )
     (data (sb-alien:* t)))

  (declare (ignore widget width height data))
  (sb-alien:with-alien ((cr2 (sb-alien:* t) cr))
    (format t "running draw callback~%")
    (cairo:set-source-rgb 1.0 0.5 0.6 cr2)
    (cairo:paint cr2)
    (cairo:stroke cr2)
    (cairo:destroy cr2)
    )
  )

(defun simple ()
  (let ((app (make-application :application-id "org.bohonghuang.cl-gtk4-example"
                               :flags gio:+application-flags-flags-none+)))
    (connect app "activate"
             (lambda (app)
               (let ((window (make-application-window :application app)))
                 (setf (window-title window)
                       "Simple Counter"
                       (window-default-size window)
                       (list 400 400))

                 (let ((box (make-box :orientation +orientation-vertical+
                                      :spacing 4)))
                   (let ((label (make-label :str "0")))
                     (setf (widget-hexpand-p label)
                           t
                           (widget-vexpand-p label)
                           t)
                     (box-append box label)
                     (let ((canvas (make-drawing-area))
                           (button-add (make-button :label "Add"))
                           (button-dec (make-button :label "Dec"))
                           (count 0))

                       (format t "gir test ~S~%" canvas)

                       (setf (gtk4:drawing-area-content-width canvas) 50
                             (gtk4:drawing-area-content-height canvas) 50)


                       ;; read more
                       ;; https://github.com/andy128k/cl-gobject-introspection

                       (gtk_drawing_area_set_draw_func
                        (gir::this-of canvas)
                        (sb-alien:alien-callable-function 'draw-callback)
                        nil
                        nil)

                       (connect canvas "realize" (lambda (widget)
                                                   (declare (ignore widget))
                                                   ;; create GDK resources here
                                                   ))

                       (connect canvas "resize" (lambda (widget)
                                                  (declare (ignore widget))))

                       ;; ---------------------------------------------------------------

                       (connect button-add "clicked" (lambda (button)
                                                       (declare (ignore button))
                                                       (setf (label-text label)
                                                             (format nil "~A" (incf count)))))

                       (connect button-dec "clicked" (lambda (button)
                                                       (declare (ignore button))
                                                       (format t "~&decreasing ====~%")
                                                       (setf (label-text label)
                                                             (format nil "~A" (decf count)))))
                       (box-append box canvas)
                       (box-append box button-add)
                       (box-append box button-dec))
                     (let ((button (make-button :label "Exit")))
                       (connect button "clicked" (lambda (button)
                                                   (declare (ignore button))
                                                   (window-destroy window)))
                       (box-append box button)))
                   (setf (window-child window)
                         box))
                 (window-present window))))
    (gio:application-run app nil)))

(progn
  (format t "running simple~%")
  (cl-gtk4::simple))
