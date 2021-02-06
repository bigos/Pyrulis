(defpackage verti/tests/main
  (:use :cl
        :verti
        :fiveam))
(in-package :verti/tests/main)

(declaim (optimize (speed 0) (debug 3)))
;; NOTE: To run this test file, execute (asdf:test-system :verti)

(def-suite all-tests
  :description "The master suite of all tests.")

(in-suite all-tests)

(test test-demo
  "This demonstrates the basic use of test and check."
  (is (listp (list 1 2)))
  (is (= 5 (+ 2 3)) "This should pass.")
  (is (= 4 4.0) "~D and ~D are  = to each other." 4 4.0))

(test test-creation-of-verts
  "Demonstrates building collection of verts."
  (let ((v1)
        (col '(("a" "a2b" "b")
               ("b" "b2c" "c")
               ("c" "c2a" "a"))))
    (is (zerop (length v1)))
    (is (= 3 (length col)))
    (setf v1 (verti::build-vert-collection col))
    (is (= 3 (length v1)))))

(test removal-of-verts
  "Prove removing works OK."
  (let* ((col '(("a" "a2b" "b")
                ("b" "b2c" "c")
                ("c" "c2a" "a")))
         (v1 (verti::build-vert-collection col))
         (v2 (verti::remove-node "a" v1)))
    (format t "~&v2 is ~A~%" v2)
    (is (= 2 (length v2)))))
