;;; gladian lisp

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

(use-foreign-library libgladian)

(defcfun ("foo" c-foo) :int
  (a :int)
  (b :string))

(progn
  (foreign-funcall "foo"
                   :int 0
                   :void))

(format t "~&quitting~%")
