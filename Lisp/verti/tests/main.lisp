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

;;; TODO finish me - (alexandria:map-combinations #'print '(a b c) :length 2)
;; (test removal-of-verts
;;   "Prove removing works OK."
;;   (let* ((col '(("a" "a2b" "b")
;;                 ("b" "b2c" "c")
;;                 ("c" "c2a" "a")))
;;         (v1 (verti::build-vert-collection col)))
;;     (let ((v2 (verti::remove-node "a" v1)))
;;       (is (equalp (verti::build-vert-collection
;;                    '(("b" "b2c" "c")))
;;                   v2)))))

(test removal-of-1
  "removal of 1"
  (let ((v1 (verti::build-vert-collection '(("a" "a2a" "a")))))

    (let ((v2 (verti::remove-node "a" v1)))
      (is (null v2) "Null expected."))
    (let ((v2 (verti::remove-node "b" v1)))
      (is (equalp v2
                  (verti::build-vert-collection '(("a" "a2a" "a"))))))    ))

(test removal-of-2
  ""
  (let ((v1 (verti::build-vert-collection '(("a" "a2a" "a")
                                            ("a" "a2b" "b")))))
    (let ((v2 (verti::remove-node "a" v1)))
      (is (equalp
           (verti::build-vert-collection '(("b" "" nil)))
           v2)))
    ;; (let ((v2 (verti::remove-node "b" v1)))
    ;;   (is (equalp
    ;;        (verti::build-vert-collection '(("a" "a2a" "a")))
    ;;        v2)))
    ))

;; (test removal-of-2-swapped-b
;;   ""
;;   (let ((v1 (verti::build-vert-collection '(("a" "a2a" "a")
;;                                             ("b" "b2a" "a")))))
;;     (let ((v2 (verti::remove-node "a" v1)))
;;       (is (equalp
;;            (verti::build-vert-collection '(("b" "" nil)))
;;            v2)))
;;     (let ((v2 (verti::remove-node "b" v1)))
;;       (is (equalp
;;            (verti::build-vert-collection '(("a" "a2a" "a")))
;;            v2)))))
