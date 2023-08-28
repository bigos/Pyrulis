(declaim (optimize (speed 0) (safety 2) (debug 3)))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(:alexandria :serapeum :dot-cons-tree :fiveam)))

(defpackage #:iii
  (:use #:cl)
  (:local-nicknames (#:se #:serapeum) (#:ax #:alexandria))
  (:export #:adder))

;; (load (compile-file "~/Programming/Pyrulis/Lisp/fiveam-in-a-one-file.lisp"))
(in-package #:iii)

(defun adder (n)
  (1+ n))

(defpackage #:iii-test
  (:use
   #:cl #:iii #:fiveam))

(in-package #:iii-test)

(test adding "adding 1"
  (is (= 1 (adder 0)))
  (is (not (= 0 (adder 0))))
  (is (not (= 2 (adder 0)))))

(explain! (run 'adding))
