(declaim (optimize (safety 3) (debug 3)))

;;;; lisp-c-gtk.lisp

(in-package #:lisp-c-gtk)


;; in the directory where you find the compiled library start emacs
;; LD_LIBRARY_PATH=. emacs &
;; and load the project
(defun main ()
  (format t "starting lisp")

  (pushnew #P"/home/jacek/Programming/Pyrulis/Lisp/lisp-c-gtk/C/builddir/" cffi:*foreign-library-directories*
           :test #'equal)
  (cffi:define-foreign-library libgladian (t (:default "libgladian")))
  (cffi:load-foreign-library '(:default "libgladian"))

  (sb-int:set-floating-point-modes :traps '(:overflow :invalid))

  (cffi:defcfun ("foo" c-foo) :int
    (a :int)
    (b :string))

  (progn
    (cffi:foreign-funcall "foo"
                          :int 0
                          :void))

  (format t "~&quitting~%"))
