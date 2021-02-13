;;; main

(in-package #:graph-toy/tests)

;;; usage
;;; (ql:quickload 'graph-toy/tests)

(def-suite all-tests
  :description "The master suite of all tests.")

(in-suite all-tests)

(defun test-quasi ()
  (run! 'all-tests))
;;; usage
;; GRAPH-TOY> (graph-toy/tests::test-quasi)

(test dummy-tests
  "Just a doc placeholder."
  (let ((gr (make-instance 'graph-toy::graph)))
    (loop for ln in (list
                     (make-instance 'graph-toy::link :source "a" :action "a2b" :target "b")
                     (make-instance 'graph-toy::link :source "b" :action "b2c" :target "c")
                     (make-instance 'graph-toy::link :source "c" :action "c2a" :target "a"))
          do (push ln (graph-toy::links gr)))

    (is (not (null gr))))
  (is (listp (list 1 2)))
  (is (= 5 (+ 2 3))))
