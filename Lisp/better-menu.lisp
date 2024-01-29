;;; better menu
(declaim (optimize (speed 0) (safety 2) (debug 3)))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(#:cl-gtk4 #:cl-gdk4 #:cl-glib #:cl-cairo2)))

(defpackage #:better-menu
  (:use #:cl))
;; (load "~/Programming/Lisp/lispy-experiments/better-menu.lisp")
;; (load (compile-file "~/Programming/Lisp/lispy-experiments/better-menu.lisp"))
(in-package #:better-menu)

;;; drawing callback ===========================================================
(cffi:defcallback %draw-func :void ((area :pointer)
                                    (cr :pointer)
                                    (width :int)
                                    (height :int)
                                    (data :pointer))
  (declare (ignore area data))

  (setf cairo:*context* (make-instance 'cairo:context
                                       :pointer cr
                                       :width width
                                       :height height
                                       :pixel-based-p nil))
  ;; ###########################################################################

  ;; call actual drawing
  (draw-objects (coerce (the (signed-byte 32) width)  'single-float)
                (coerce (the (signed-byte 32) height) 'single-float)))

(defun simulate-draw-func (w h)
  (let* ((surface (cairo:create-image-surface :argb32
                                              w
                                              h)))
    (let* ((ctx (cairo:create-context surface)))
      (setf  cairo:*context* ctx)
      ;; #######################################################################

      ;; call actual drawing
      (draw-objects w
                    h))

    ;; put drawn surface to a file
    (cairo:surface-write-to-png surface
                                (format nil
                                        "/tmp/cairo-simulate-drawing-~A.png"
                                        (get-internal-run-time)))))

(defun draw-objects (w h)               ; view
  (format t ">>>>>>>> in draw-objects ~S " cairo:*context*)
  (let ((cnt (format nil "~S" *selection*))
        (tw 0)
        (th 0)
        (tpx 0)
        (tpy 0))
    (cairo:set-source-rgb 0 0 0)
    (cairo:select-font-face "Ubuntu Mono" :normal :bold)
    (cairo:set-font-size 20)

    (multiple-value-bind  (xb yb width height)
        (cairo:text-extents *selection*)
      (declare (ignore xb yb))
      (setf
       tw width
       th height))

    ;; centering
    (setf tpx (- (/ w  2)
                 (/ tw 2) )
          tpy (- (/ h  2)
                 (/ th 2)))

    (cairo:move-to tpx tpy)
    (cairo:show-text cnt)

    (cairo:move-to tpx (+ tpy (* th 2)))
    (cairo:show-text (format nil "~S" (list tw th)))
    ))

;; ================================= MENU ======================================
;; https://docs.gtk.org/gio/ctor.MenuItem.new_section.html ; ===================

(defun prepare-radio-action (app action-name default)
      (let ((action (gio:make-stateful-simple-action :name action-name
                                                     :parameter-type (glib:make-variant-type
                                                                      :type-string "s")
                                                     :state (glib:make-string-variant
                                                             :string default))))
        (gio:action-map-add-action app action)
        (gtk4:connect action "activate"
                      (lambda (event parameter)
                        (declare (ignore event))
                        (gio:action-change-state action parameter)

                        (apply 'process-menu-action (list :radio
                                                          action-name
                                                          (glib:variant-string
                                                           (gio:action-state action))))))
        (gobj:object-unref action)))

(defun prepare-item-radio (app menu label action-name string)
    (declare (ignore app))
  (progn
    (let ((item (gio:make-menu-item :model menu
                                    :label label
                                    :detailed-action (format nil "app.~A" action-name))))
      (setf (gio:menu-item-action-and-target-value item)
            (list "app.color-scheme" (glib:make-string-variant
                                      :string string)))
      item)))

(defun prepare-item-bool (app menu label action-name default &key (disabled nil))
  (progn
    (let ((action (gio:make-stateful-simple-action :name action-name
                                                   :parameter-type nil
                                                   :state (glib:make-boolean-variant
                                                           :value default))))
      (when disabled (setf (gio:simple-action-enabled-p action) nil))
      (gio:action-map-add-action app action)

      (gtk:connect action "activate"
                   (lambda (event parameter)
                     (declare (ignore event parameter))
                     (gio:action-change-state action (glib:make-boolean-variant
                                                      :value (if (zerop (glib:variant-hash (gio:action-state action)))
                                                                 T
                                                                 nil)))
                     (apply 'process-menu-action
                             (list :bool
                                   action-name
                                   (glib:variant-hash (gio:action-state action))))))
      (gobj:object-unref action))

    (gio:make-menu-item :model menu
                        :label label
                        :detailed-action (format nil  "app.~A" action-name))))

(defun prepare-item-simple (app menu label action-name &key (disabled nil))
  (progn
    (let ((action (gio:make-simple-action :name action-name
                                          :parameter-type nil)))
      (when disabled (setf (gio:simple-action-enabled-p action) nil))
      (gio:action-map-add-action app action)

      (gtk4:connect action "activate"
                    (lambda (event parameter)
                      (declare (ignore event parameter))

                      (apply 'process-menu-action (list :simple action-name))))
      (gobj:object-unref action))

    (gio:make-menu-item :model menu
                        :label label
                        :detailed-action (format nil  "app.~A" action-name))))

(defun prepare-section (label section)
  (gio:make-section-menu-item
   :label label
   :section  section))

(defun prepare-submenu (label &rest submenu-items)
  (list :submenu label
        (apply 'build-items submenu-items)))

(defun build-items (&rest items)
  (let ((submenu (gio:make-menu)))
    (apply 'build-menu submenu items)
    submenu))

(defun build-menu (submenu &rest items)
  (loop for i in items
        for item-class-string = (when (typep i 'gir::object-instance)
                                  (format nil "~A"
                                          (gir:gir-class-of i)))
        do (cond
             ((equalp item-class-string "#O<MenuItem>")
              (gio:menu-append-item submenu i))
             ((and (null item-class-string)
                   (consp i)
                   (eq :submenu (first i)))
              (gio:menu-append-submenu submenu (second i) (third i)))
             (T (error "unexpected item-class-string or option ~S" item-class-string)))))

;; ================================= MENU code ends here =======================

(defun menu-bar-menu (app)
  (let ((menu (gio:make-menu)))
    (build-menu menu
                (prepare-submenu "Window"

                                 (prepare-item-bool app menu "Fullscreen" "fullscreen" nil)
                                 (prepare-item-bool app menu "Always On Top" "always-on-top" T :disabled T)

                                 (prepare-section "Q Options"
                                                  (build-items
                                                   (prepare-item-simple app menu "Q1" "q1")
                                                   (prepare-item-simple app menu "Q2" "q2")

                                                   (prepare-submenu "Abyss"
                                                                    (prepare-item-simple app menu "Abyss 1" "abyss-1")
                                                                    (prepare-item-simple app menu "Abyss 2" "abyss-2" :disabled T)
                                                                    (prepare-item-simple app menu "Abyss 3" "abyss-3"))

                                                   (prepare-item-simple app menu "After abyss" "after-abyss")))

                                 (prepare-submenu "Deeper"
                                                  (prepare-item-simple app menu "W1" "w1")
                                                  (prepare-item-simple app menu "W2" "w2")
                                                  (prepare-item-simple app menu "W3" "w3")

                                                  (prepare-submenu "Deepest"
                                                                   (prepare-submenu "abysmal"
                                                                                    (prepare-item-simple app menu "aW1" "aw1")
                                                                                    (prepare-item-simple app menu "aW2" "aw2")
                                                                                    (prepare-item-simple app menu "aW3" "aw3"))))

                                 (prepare-section nil
                                                  (build-items
                                                   (prepare-item-simple app menu "Quit" "quit"))))

                (prepare-submenu "Color Scheme"
                                 (prepare-section nil
                                                  (progn
                                                    (prepare-radio-action app "color-scheme" "LIGHT")
                                                    (build-items
                                                     (prepare-item-radio app menu "Transparent" "color-scheme" "TRANSPARENT")
                                                     (prepare-item-radio app menu "Light" "color-scheme" "LIGHT")
                                                     (prepare-item-radio app menu "Dark" "color-scheme" "DARK"))))

                                 (prepare-section nil
                                                  (build-items
                                                   (prepare-item-bool app menu "Colorful" "colorful" T)))))

    (values menu)))

(defun process-menu-action (action-type action &optional arg)
  (setf *selection*
        (format nil "processing ~S ~S ~S~%" action-type action arg))
  (case action-type
    ;; null arg
    (:simple)
    ;; 0 or 1 arg
    (:bool)
    ;; string arg
    (:radio))
  (when *canvas*
    (gtk4:widget-queue-draw *canvas*)))

(defparameter *selection* "please select menu item")
(defparameter *canvas* nil)

(defun window ()
  (let ((app (gtk:make-application :application-id "org.bigos.gtk4-example.better-menu"
                                   :flags gio:+application-flags-flags-none+)))
    (gtk4:connect app "activate"
                  (lambda (app)
                    (let ((window (gtk4:make-application-window :application app)))
                      (setf
                       (gtk4:application-menubar app) (menu-bar-menu app)
                       (gtk4:application-window-show-menubar-p window) T)

                      (setf
                       (gtk4:window-title window) "Better Menu"
                       (gtk4:window-default-size window) (list 400 400))

                      (let ((box (gtk4:make-box :orientation gtk4:+orientation-vertical+
                                                :spacing 0)))
                        (let ((canvas (gtk4:make-drawing-area)))
                          (setf *canvas* canvas
                                (gtk4:widget-vexpand-p canvas) T
                                (gtk4:drawing-area-draw-func canvas) (list (cffi:callback %draw-func)
                                                                           (cffi:null-pointer)
                                                                           (cffi:null-pointer)))

                          (gtk4:box-append box canvas))
                        (setf (gtk4:window-child window) box))

                      (format t "actions defined for app ~A~%"  (gio:action-group-list-actions app))

                      (gtk:window-present window))))

    (let ((status (gtk:application-run app nil)))
      (setf *canvas* nil)
      (gobj:object-unref app)
      status)))
