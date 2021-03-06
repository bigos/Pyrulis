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

;;; combinastions for buiding collection come from (verti::build-combinations '(a b c))
(test removal-of-1
  "removal of 1"
  (let ((v1 (verti::build-vert-collection '(("a" "a2a" "a")))))

    (let ((v2 (verti::remove-node "a" v1)))
      (is (null v2)))
    (let ((v2 (verti::remove-node "b" v1)))
      (is (equalp v2
                  (verti::build-vert-collection '(("a" "a2a" "a"))))))    ))

(test removal-of-2
  (let ((v1 (verti::build-vert-collection '(("a" "a2a" "a")
                                            ("a" "a2b" "b")))))
    (let ((v2 (verti::remove-node "a" v1)))
      (is (equalp
           (verti::build-vert-collection '(("b" "" nil)))
           v2)))
    (let ((v2 (verti::remove-node "b" v1)))
      (is (equalp
           (verti::build-vert-collection '(("a" "a2a" "a")))
           v2)))
    ))

(test removal-of-2-swapped-b
  (let ((v1 (verti::build-vert-collection '(("a" "a2a" "a")
                                            ("b" "b2a" "a")))))
    (let ((v2 (verti::remove-node "a" v1)))
      (is (equalp
           (verti::build-vert-collection '(("b" "" nil)))
           v2)))
    (let ((v2 (verti::remove-node "b" v1)))
      (is (equalp
           (verti::build-vert-collection '(("a" "a2a" "a")))
           v2)))))

(test removal-of-3
  "Prove removing works OK."
  (let ((v1 (verti::build-vert-collection '(("a" "a2b" "b")
                                            ("b" "b2c" "c")
                                            ("c" "c2a" "a")))))
    (let ((v2 (verti::remove-node "a" v1)))
      (is (equalp (verti::build-vert-collection
                   '(("b" "b2c" "c")))
                  v2)))
    (let ((v3 (verti::remove-node "b" v1)))
      (is (equalp (verti::build-vert-collection
                   '(("c" "c2a" "a")))
                  v3)))
    (let ((v4 (verti::remove-node "c" v1)))
      (is (equalp (verti::build-vert-collection
                   '(("a" "a2b" "b")))
                  v4)))))

(test removal-of-4
  "Prove removing 4 combinations works OK."
  (let ((v1 (verti::build-vert-collection '(("c" "c2d" "d")
                                            ("b" "b2d" "d")
                                            ("b" "b2c" "c")
                                            ("a" "a2d" "d")
                                            ("a" "a2c" "c")
                                            ("a" "a2b" "b")))))
    (let ((v2 (verti::remove-node "a" v1)))
      (is (equalp (verti::build-vert-collection
                   '(("b" "b2c" "c")
                     ("b" "b2d" "d")
                     ("c" "c2d" "d")))
                  v2)))
    (let ((v3 (verti::remove-node "b" v1)))
      (is (equalp (verti::build-vert-collection
                   '(("a" "a2c" "c")
                     ("a" "a2d" "d")
                     ("c" "c2d" "d")))
                  v3)))
    (let ((v4 (verti::remove-node "c" v1)))
      (is (equalp (verti::build-vert-collection
                   '(("a" "a2b" "b")
                     ("a" "a2d" "d")
                     ("b" "b2d" "d")))
                  v4)))))
