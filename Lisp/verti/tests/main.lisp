(defpackage verti/tests/main
  (:use :cl
        :verti
        :fiveam))
(in-package :verti/tests/main)

;; NOTE: To run this test file, execute (asdf:test-system :verti)

(test test-demo
      "This demonstrates the basic use of test and check."
      (is (listp (list 1 2)))
      (is (= 5 (+ 2 3)) "This should pass.")  ; &rest reason-args
      (is (= 4 4.1) "~D and ~D are not = to each other." 4 4.1))
