(declaim (optimize (safety 3) (debug 3)))

;;; gladian lisp

;; in the directory where you find the compiled library execute
;; LD_LIBRARY_PATH=. sbcl --load ../gladian.lisp

(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"
                                       (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(format t "starting lisp")

(ql:quickload :cffi)

(defpackage #:cffi-example
  (:use #:common-lisp #:cffi))

(in-package #:cffi-example)


(define-foreign-library libgladian
  (t (:default "libgladian")))

;; (use-foreign-library libgladian)

(pushnew #P"/home/jacek/Programming/Pyrulis/Idris/CGlade/builddir/" *foreign-library-directories*
         :test #'equal)

(load-foreign-library '(:default "libgladian"))

(sb-int:set-floating-point-modes :traps '(:overflow :invalid))

(defcfun ("foo" c-foo) :int
  (a :int)
  (b :string))

(progn
  (foreign-funcall "foo"
                   :int 0
                   :void))

(format t "~&quitting~%")

(sb-ext:exit)
