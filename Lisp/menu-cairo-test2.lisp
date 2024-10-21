(declaim (optimize (speed 1) (safety 3) (debug 3)))

;;;; examples/gdk4-cairo.lisp

;;;; Copyright (C) 2022-2023 Bohong Huang
;;;;
;;;; This program is free software: you can redistribute it and/or modify
;;;; it under the terms of the GNU Lesser General Public License as published by
;;;; the Free Software Foundation, either version 3 of the License, or
;;;; (at your option) any later version.
;;;;
;;;; This program is distributed in the hope that it will be useful,
;;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;;; GNU Lesser General Public License for more details.
;;;;
;;;; You should have received a copy of the GNU Lesser General Public License
;;;; along with this program.  If not, see <https://www.gnu.org/licenses/>.


(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(:alexandria :serapeum :cl-gtk4 :cl-gdk4 :cl-cairo2 :defclass-std)))

(cl:defpackage cairo-gobject
  (:use)
  (:export #:*ns*))

(cl:in-package #:cairo-gobject)

(gir-wrapper:define-gir-namespace "cairo")

(cl:defpackage menu-cairo-test
  (:use #:cl #:gtk4)
  (:export #:cairo-test))
;; (load (compile-file "/home/jacek/Programming/Pyrulis/Lisp/menu-cairo-test2.lisp"))
(cl:in-package #:menu-cairo-test)

(cffi:defcstruct gdk-rgba
  (red :float)
  (green :float)
  (blue :float)
  (alpha :float))

(defmacro with-gdk-rgba ((pointer color) &body body)
  `(locally
       #+sbcl (declare (sb-ext:muffle-conditions sb-ext:compiler-note))
       (cffi:with-foreign-object (,pointer '(:struct gdk-rgba))
         (let ((,pointer (make-instance 'gir::struct-instance
                                        :class (gir:nget gdk::*ns* "RGBA")
                                        :this ,pointer)))
           (gdk:rgba-parse ,pointer ,color)
           (locally
               #+sbcl (declare (sb-ext:unmuffle-conditions sb-ext:compiler-note))
               ,@body)))))

(declaim (ftype (function (t t t t) t) draw-func))

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
               width height)))

(defun menu-test-menu ()
  (let ((menu (gio:make-menu)))
    (let ((submenu (gio:make-menu)))
      (gio:menu-append-item submenu (gio:make-menu-item :model menu :label "Open" :detailed-action "app.open"))
      (gio:menu-append-item submenu (gio:make-menu-item :model menu :label "Exit" :detailed-action "app.exit"))
      (gio:menu-append-submenu menu "File" submenu))
    (let ((submenu (gio:make-menu)))
      (gio:menu-append-item submenu (gio:make-menu-item :model menu :label "About" :detailed-action "app.about"))
      (gio:menu-append-submenu menu "Help" submenu))
    (values menu)))

(defun menu-test-about-dialog ()
  (let ((dialog (make-about-dialog))
        (system (asdf:find-system :cl-gtk4)))
    (setf (about-dialog-authors dialog) (list (asdf:system-author system) "Jacek Podkanski")
          (about-dialog-website dialog) (asdf:system-homepage system)
          (about-dialog-version dialog) (asdf:component-version system)
          (about-dialog-program-name dialog) "Cairo and menu test"
          (about-dialog-comments dialog) "This is a cl-gtk4 test."
          (about-dialog-logo-icon-name dialog) "application-x-addon")
    (values dialog)))

(defun define-menu-actions (window)
  (let ((action (gio:make-simple-action :name "exit"
                                        :parameter-type nil)))
    (gio:action-map-add-action *application* action)
    (connect action "activate"
             (lambda (action param)
               (declare (ignore action param))
               (gtk::destroy-all-windows-and-quit))))
  (let ((action (gio:make-simple-action :name "about"
                                        :parameter-type nil)))
    (gio:action-map-add-action *application* action)
    (connect action "activate"
             (lambda (action param)
               (declare (ignore action param))
               (let ((dialog (menu-test-about-dialog)))
                 (setf (window-modal-p dialog) t
                       (window-transient-for dialog) window)
                 (window-present dialog))))))

(defun draw-func (area cr width height)
  (declare (ignore area)
           (optimize (speed 3)
                     (debug 0)
                     (safety 0)))
  (let ((width (coerce (the fixnum width) 'single-float))
        (height (coerce (the fixnum height) 'single-float))
        (fpi (coerce pi 'single-float)))
    (let* ((radius (/ (min width height) 2.0))
           (stroke-width (/ radius 8.0))
           (button-radius (* radius 0.4)))
      (declare (type single-float radius stroke-width button-radius))
      (with-gdk-rgba (color "#000000")
        (cairo:arc (/ width 2.0) (/ height 2.0) radius 0.0 (* 2.0 fpi))
        (gdk:cairo-set-source-rgba cr color)
        (cairo:fill-path))
      (with-gdk-rgba (color "#FF0000")
        (cairo:arc (/ width 2.0) (/ height 2.0) (- radius stroke-width) pi (* 2.0 fpi))
        (gdk:cairo-set-source-rgba cr color)
        (cairo:fill-path))
      (with-gdk-rgba (color "#FFFFFF")
        (cairo:arc (/ width 2.0) (/ height 2.0) (- radius stroke-width) 0.0 fpi)
        (gdk:cairo-set-source-rgba cr color)
        (cairo:fill-path))
      (with-gdk-rgba (color "#000000")
        (let ((bar-length (sqrt (- (expt (* radius 2) 2.0) (expt stroke-width 2.0)))))
          (declare (type single-float bar-length))
          (cairo:rectangle (+ (- (/ width 2.0) radius) (- radius (/ bar-length 2.0)))
                           (+ (- (/ height 2.0) radius) (- radius (/ stroke-width 2.0)))
                           bar-length
                           stroke-width))
        (gdk:cairo-set-source-rgba cr color)
        (cairo:fill-path))
      (with-gdk-rgba (color "#000000")
        (cairo:arc (/ width 2.0) (/ height 2.0) button-radius 0.0 (* 2.0 fpi))
        (gdk:cairo-set-source-rgba cr color)
        (cairo:fill-path))
      (with-gdk-rgba (color "#FFFFFF")
        (cairo:arc (/ width 2.0) (/ height 2.0) (- button-radius stroke-width) 0.0 (* 2.0 fpi))
        (gdk:cairo-set-source-rgba cr color)
        (cairo:fill-path)))))

;; (define-application (:name cairo-test
;;                      :id "org.bigos.gdk4-menu-cairo-test2")
;;   (define-main-window (window (make-application-window :application *application*))
;;     (setf (window-title window) "Drawing Area Test with Menu")

;;     (define-menu-actions window)

;;     (let ((window-box (make-box :orientation +orientation-vertical+
;;                                 :spacing 0)))
;;       (let ((menu-bar (make-popover-menu-bar :model (menu-test-menu))))
;;         (box-append window-box menu-bar))
;;       (let ((area (gtk:make-drawing-area)))
;;         (setf (drawing-area-content-width area) 200
;;               (drawing-area-content-height area) 200
;;               (drawing-area-draw-func area) (list (cffi:callback %draw-func)
;;                                                   (cffi:null-pointer)
;;                                                   (cffi:null-pointer)))
;;         (box-append window-box area))
;;       (setf (window-child window) window-box))
;;     (unless (widget-visible-p window)
;;       (window-present window))))

(MACROLET ((DEFINE-MAIN-WINDOW (GTK4::BINDING &BODY GTK4::BODY)
             (DESTRUCTURING-BIND
                 (GTK4::WIN-BIND GTK4::WIN-FORM)
                 (ETYPECASE GTK4::BINDING
                   (LIST GTK4::BINDING)
                   (SYMBOL (LIST (GENSYM) GTK4::BINDING)))
               `(PROGN
                 (DEFUN ,'ORG.BIGOS.GDK4-MENU-CAIRO-TEST2.MAIN-WINDOW-CONTENT
                        (,GTK4::WIN-BIND)
                   (DECLARE (IGNORABLE ,GTK4::WIN-BIND))
                   ,@GTK4::BODY)
                 (DEFUN ,'ORG.BIGOS.GDK4-MENU-CAIRO-TEST2.MAIN
                        (&OPTIONAL GTK4::ARGV)
                   (LET ((GTK4::APP
                          (MAKE-APPLICATION :APPLICATION-ID
                                            ,'"org.bigos.gdk4-menu-cairo-test2"
                                            :FLAGS ,'0)))
                     (CONNECT GTK4::APP "activate"
                              (LAMBDA (GTK4::APP)
                                (DECLARE (IGNORE GTK4::APP))
                                (LET ((GTK4::WIN
                                       (SETF ,'*ORG.BIGOS.GDK4-MENU-CAIRO-TEST2.MAIN-WINDOW*
                                               ,GTK4::WIN-FORM)))
                                  (,'ORG.BIGOS.GDK4-MENU-CAIRO-TEST2.MAIN-WINDOW-CONTENT
                                   GTK4::WIN)
                                  (CONNECT GTK4::WIN "destroy"
                                           (LAMBDA (GTK4::WIN)
                                             (DECLARE (IGNORE GTK4::WIN))
                                             (SETF ,'*ORG.BIGOS.GDK4-MENU-CAIRO-TEST2.MAIN-WINDOW*
                                                     NIL))))))
                     (APPLICATION-RUN GTK4::APP GTK4::ARGV)))
                 ,(WHEN 'CAIRO-TEST
                    `(SETF (FDEFINITION ','CAIRO-TEST)
                             (FDEFINITION
                              ','ORG.BIGOS.GDK4-MENU-CAIRO-TEST2.MAIN)))
                 (EVAL-WHEN (:LOAD-TOPLEVEL)
                   (WHEN ,'*ORG.BIGOS.GDK4-MENU-CAIRO-TEST2.MAIN-WINDOW*
                     (IDLE-ADD
                      (LAMBDA ()
                        (,'ORG.BIGOS.GDK4-MENU-CAIRO-TEST2.MAIN-WINDOW-CONTENT
                         ,'*ORG.BIGOS.GDK4-MENU-CAIRO-TEST2.MAIN-WINDOW*)
                        NIL))))))))
  (defvar *org.bigos.gdk4-menu-cairo-test2.main-window* nil)
  (define-main-window (window
                       (make-application-window :application *application*))
      (setf (window-title window)
            "drawing area test with menu")
    (define-menu-actions window)
    (let ((window-box
           (make-box :orientation +orientation-vertical+ :spacing 0)))
      (let ((menu-bar (make-popover-menu-bar :model (menu-test-menu))))
        (box-append window-box menu-bar))
      (let ((area (make-drawing-area)))
        (setf (drawing-area-content-width area) 200
              (drawing-area-content-height area) 200
              (drawing-area-draw-func area) (list (cffi:callback %draw-func)
                                                  (cffi-sys:null-pointer)
                                                  (cffi-sys:null-pointer)))
        (box-append window-box area))
      (setf (window-child window)
            window-box))
    (unless (widget-visible-p window)
      (window-present window))))
