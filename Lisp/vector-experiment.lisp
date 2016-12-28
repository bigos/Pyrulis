;;; vector experiment

(format t "Vector experiment~%")

(ql:quickload :vecto)

(defpackage #:vecto-examples
  (:use #:cl #:vecto))

(in-package #:vecto-examples)

(defun radiant-lambda (file)
  (with-canvas (:width 900 :height 900)
    (let ((font (get-font (make-pathname
                           :directory "/usr/share/fonts/truetype/msttcorefonts"
                           :name "Verdana"
                           :type "ttf")))
          (step (/ pi 6)))
      (set-rgb-fill 1.0 0.65 0.3)
      (rectangle 10 10 880 880)
      (fill-path)

      (set-rgb-fill 0.7 1.0 0.5)
      (set-font font 40)
      (translate 450 450)
      (draw-centered-string 0 -10 #(#x3BB))

      (set-rgb-stroke 1 0 0)
      (centered-circle-path 0 0 400)
      (stroke)

      (set-rgba-stroke 0 0 1.0 0.5)
      (set-line-width 14)
      (dotimes (i 12)
        (with-graphics-state
          (rotate (* i step))
          (move-to 390 0)
          (line-to 410 0)
          (stroke)))
      (save-png file))))

(defun drawing (file)
  (radiant-lambda file))

;;; ----------------------------------------------------------------------------
(defun main ()
  (with-open-file (s (make-pathname :directory
                                    (pathname-directory
                                     (parse-namestring *load-pathname*))
                                    :name "image"
                                    :type "png")
                     :direction :output
                     :if-exists :supersede
                     :if-does-not-exist :create)
    (drawing s)))

(main)
