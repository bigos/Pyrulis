(defpackage verti/tests/main
  (:use :cl
        :verti
        :rove))
(in-package :verti/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :verti)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
