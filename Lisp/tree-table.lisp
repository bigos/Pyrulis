;;; tree table

(declaim (optimize (speed 0) (safety 3) (debug 3)))

(ql:quickload (list :alexandria :draw-cons-tree))

(defpackage #:tree-table
  (:use #:cl))

(in-package #:tree-table)              ;---------------------------------------


;; | a
;; | b1           | b2     | b3
;; | c1 | d1 | e1 | c2 |d2 | c3

;; CL-USER> (draw-cons-tree:draw-tree '(a (b1
;;                                          (c1 d1 e1))
;;                                        (b2
;;                                          (c2 d2))
;;                                        (b3
;;                                          (c3))))
