;;;; impex.lisp

(in-package #:impex)

(defun runme ()
  (format t "Running~%")
  (foo1)
  (bar1)
  (baz1))

(in-package #:foo)
(defun foo1 () (format t "foo1~%") (foo2))
(defun foo2 () (format t "foo2~%"))

(in-package #:bar)
(defun bar1 () (format t "bar1~%") (bar2))
(defun bar2 () (format t "bar2~%"))

(in-package #:baz)
(defun baz1 () (format t "baz1~%") (baz2))
(defun baz2 () (format t "baz2~%"))
