(ql:quickload :lisp-unit)

(defpackage :simple-tests
  (:use :common-lisp :lisp-unit))

(in-package :simple-tests)

(setf *print-failures* t)

(define-test test-addition
  "test simple addition"
  (assert-equal 3 (+ 1 2))
  (assert-equal 1 (+ 0 0)))

(define-test test-multiplication
  "test simple multiplication"
  (assert-equal 9 (* 3 3)))

(run-tests :all)
; (run-tests '(test-addition test-multiplication))

