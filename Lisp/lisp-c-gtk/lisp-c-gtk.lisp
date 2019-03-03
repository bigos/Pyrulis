(declaim (optimize (safety 3) (debug 3)))

;;;; lisp-c-gtk.lisp

(in-package #:lisp-c-gtk)


;; in the directory where you find the compiled library start emacs
;; LD_LIBRARY_PATH=. emacs &
;; and load the project
(defun main ()
  (format t "starting lisp")

  (cffi:define-foreign-library libgtk (t (:default "libgtk-3")))
  (cffi:use-foreign-library libgtk)

  ;; (sb-int:set-floating-point-modes :traps '(:overflow :invalid))

  ;; (cffi:defcfun ("foo" c-foo) :int
  ;;   (a :int)
  ;;   (b :string))

  ;; (progn
  ;;   (cffi:foreign-funcall "foo"
  ;;                         :int 0
  ;;                         :void))

  (format t "~&quitting~%"))
